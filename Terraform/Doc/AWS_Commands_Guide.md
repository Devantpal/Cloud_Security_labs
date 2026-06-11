# DevSecOps Secure Cloud Project – Complete AWS & Linux Command Reference

## Project Overview

This project was built using Terraform on AWS and included:

* Custom VPC
* Public Subnet
* Private Subnet
* Internet Gateway
* Route Tables
* Bastion Host
* Private EC2 Instance
* Security Groups
* CloudWatch Monitoring
* CloudWatch Alarms
* SNS Email Alerts
* CloudTrail
* VPC Flow Logs
* S3 Log Storage
* Terraform Automation

---

# Phase 1: Terraform Initialization

## Initialize Terraform

 
terraform init
 

Purpose:
Downloads AWS provider plugins and initializes the Terraform working directory.

Example:

 
terraform init
 

---

## Validate Terraform Configuration

 
terraform validate
 

Purpose:
Checks Terraform files for syntax errors.

Example:

 
terraform validate
 

---

## Preview Infrastructure

 
terraform plan
 

Purpose:
Shows resources Terraform will create before deployment.

Example:

 
terraform plan
 

---

# Phase 2: Deploy Infrastructure

## Create AWS Resources

 
terraform apply
 

Purpose:
Creates all AWS resources defined in Terraform.

Example:

 
terraform apply
 

Type:

  
yes
 

to confirm deployment.

---

## Verify Terraform Resources

 
terraform state list
 

Purpose:
Lists all resources managed by Terraform.

Example Output:

  
aws_vpc.dev_custom_vpc
aws_subnet.public_subnet
aws_subnet.private_subnet
aws_security_group.bastion_sg
aws_security_group.private_sg
 

---

# Phase 3: Find Latest Amazon Linux AMI

## Get Latest Amazon Linux 2023 AMI

 
aws ssm get-parameters \
--names /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
--region ap-south-1
 

Purpose:
Retrieves latest Amazon Linux AMI ID automatically.

Example Output:

  
ami-0db56f446d44f2f09
 

---

# Phase 4: Free Tier Instance Validation

## Check Free Tier Eligible Instance Types

 
aws ec2 describe-instance-types \
--filters Name=free-tier-eligible,Values=true \
--region ap-south-1 \
--query "InstanceTypes[*].InstanceType" \
--output table
 

Purpose:
Finds EC2 types eligible under AWS Free Tier.

Example Output:

  
t3.micro
t4g.micro
 

---

# Phase 5: SSH into Bastion Host

## Secure PEM File

 
chmod 400 dev-key.pem
 

Purpose:
Sets secure permissions for SSH private key.

---

## Connect to Bastion Host

 
ssh -i dev-key.pem ec2-user@PUBLIC_IP
 

Example:

 
ssh -i dev-key.pem ec2-user@3.109.182.194
 

Purpose:
Connects to Bastion Host.

---

# Phase 6: Verify Private Network Access

## Test Connectivity

 
ping 10.0.2.128
 

Purpose:
Checks communication with private server.

---

## Attempt SSH

 
ssh ec2-user@10.0.2.128
 

Purpose:
Tests private server accessibility.

---

# Phase 7: Bastion Host to Private Server

## Copy PEM File to Bastion

 
scp -i dev-key.pem dev-key.pem ec2-user@PUBLIC_IP:/home/ec2-user/
 

Example:

 
scp -i dev-key.pem dev-key.pem ec2-user@3.109.182.194:/home/ec2-user/
 

Purpose:
Transfers private key securely.

---

## SSH to Bastion

 
ssh -i dev-key.pem ec2-user@PUBLIC_IP
 

---

## Set Key Permissions

 
chmod 400 dev-key.pem
 

---

## SSH from Bastion to Private Server

 
ssh -i dev-key.pem ec2-user@10.0.2.128
 

Purpose:
Accesses private EC2 through Bastion Host.

---

# Phase 8: Linux Administration

## Update Packages

 
sudo yum update -y
 

Purpose:
Updates installed packages.

---

## Install Stress Tool

 
sudo dnf install stress -y
 

Purpose:
Installs CPU stress testing utility.

---

# Phase 9: CloudWatch Monitoring Testing

## Generate CPU Load

 
stress --cpu 2 --timeout 600
 

Purpose:
Creates high CPU usage.

Explanation:

* Uses 2 CPU workers
* Runs for 600 seconds
* Triggers CloudWatch alarm

---

# Phase 10: CloudTrail Verification

## List Trails

 
aws cloudtrail describe-trails \
--region ap-south-1
 

Purpose:
Lists CloudTrail trails.

---

## Check Trail Status

 
aws cloudtrail get-trail-status \
--name devsecops-trail \
--region ap-south-1
 

Purpose:
Verifies CloudTrail logging status.

Expected:

"IsLogging": true
 

---

# Phase 11: VPC Flow Logs Verification

## Check Log Groups

 
aws logs describe-log-groups \
--region ap-south-1
 

Purpose:
Lists CloudWatch log groups.

---

## Check Log Streams

 
aws logs describe-log-streams \
--log-group-name vpc-flowlogs \
--region ap-south-1
 

Purpose:
Shows VPC Flow Log streams.

---

# Phase 12: S3 Verification

## View CloudTrail Logs

aws s3 ls s3://devsecops-cloudtrail-448830788768 --recursive

Purpose:
Lists CloudTrail log files stored in S3.

---

# Phase 13: Infrastructure Cleanup

## Destroy Infrastructure

terraform destroy

Purpose:
Deletes all AWS resources created by Terraform.

Example:

terraform destroy

Type:

yes

to confirm.

---

## Verify State

terraform state list


Purpose:
Ensures all resources are removed.

---

## Remove Terraform State Files

 
rm terraform.tfstate
rm terraform.tfstate.backup
 

Purpose:
Cleans local Terraform state.

---

## Remove SSH Key

rm dev-key.pem

Purpose:
Removes local private key after project completion.

---

# Final Result

Successfully Implemented:

✓ VPC
✓ Public Subnet
✓ Private Subnet
✓ Internet Gateway
✓ Route Tables
✓ Security Groups
✓ Bastion Host
✓ Private EC2
✓ SSH Access
✓ CloudWatch Monitoring
✓ CloudWatch Alarms
✓ SNS Email Notifications
✓ CloudTrail Logging
✓ S3 Audit Storage
✓ VPC Flow Logs
✓ IAM Roles
✓ Terraform Automation
✓ Complete Infrastructure Cleanup

Project Type:
AWS DevSecOps Infrastructure as Code (IaC) Project using Terraform
