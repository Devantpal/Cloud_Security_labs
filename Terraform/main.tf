resource "aws_vpc" "dev_custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "dev-custom-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.dev_custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.dev_custom_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_custom_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

# Public Route Table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dev_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Route Table Association

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dev_custom_vpc.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
# Bastion Security Group

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH from Internet"
  vpc_id      = aws_vpc.dev_custom_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# Private Instance Security Group

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow SSH from Bastion"
  vpc_id      = aws_vpc.dev_custom_vpc.id

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg"
  }
}

# Bastion Host

resource "aws_instance" "bastion_host" {
  ami                    = "ami-0db56f446d44f2f09"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = "dev-key"

  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}

# Private Server

resource "aws_instance" "private_server" {
  ami                    = "ami-0db56f446d44f2f09"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = "dev-key"

  tags = {
    Name = "private-server"
  }
}

# SNS Topic

resource "aws_sns_topic" "alerts" {
  name = "devsecops-alerts"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "amanraaj051@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "bastion_cpu_alarm" {

  alarm_name          = "Bastion-HighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = aws_instance.bastion_host.id
  }

  alarm_description = "CPU exceeds 80%"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "private_cpu_alarm" {

  alarm_name          = "PrivateServer-HighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = aws_instance.private_server.id
  }

  alarm_description = "CPU exceeds 80%"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "devsecops-cloudtrail-448830788768"

  tags = {
    Name = "cloudtrail-logs"
  }
}

resource "aws_cloudtrail" "main_trail" {
  name                          = "devsecops-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  depends_on = [
    aws_s3_bucket_policy.cloudtrail_policy
  ]
}

resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_bucket.arn
      },

      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"

        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }

        Action = "s3:PutObject"

        Resource = "${aws_s3_bucket.cloudtrail_bucket.arn}/AWSLogs/448830788768/*"

        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "flowlogs" {
  name = "vpc-flowlogs"
}

resource "aws_iam_role" "flowlogs_role" {
  name = "flowlogs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "flowlogs_policy" {
  name = "flowlogs-policy"
  role = aws_iam_role.flowlogs_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]

      Resource = "*"
    }]
  })
}

resource "aws_flow_log" "vpc_flowlog" {

  iam_role_arn = aws_iam_role.flowlogs_role.arn

  log_destination = aws_cloudwatch_log_group.flowlogs.arn

  traffic_type = "ALL"

  vpc_id = aws_vpc.dev_custom_vpc.id
}
