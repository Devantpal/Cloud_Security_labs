# AWS DevSecOps Infrastructure using Terraform – Step-by-Step Implementation Notes

## Project Objective

The objective of this project was to build a secure AWS infrastructure using Terraform Infrastructure as Code (IaC). The environment follows security best practices by deploying a Bastion Host in a public subnet and a Private EC2 instance in a private subnet. Monitoring, auditing, alerting, and network visibility were implemented using AWS native services.

---

# Phase 1: Environment Preparation

## Step 1: Install Terraform

Terraform was installed on a Debian/Linux workstation.

Purpose:
Terraform allows cloud infrastructure to be created and managed through code instead of manually clicking in the AWS Console.

Example:
Instead of manually creating a VPC, subnet, route table, and EC2 instance, Terraform provisions everything automatically using configuration files.

Commands:

terraform init
terraform plan
terraform apply

---

# Phase 2: AWS Provider Configuration

## Step 2: Configure AWS Provider

Terraform was configured to communicate with AWS using AWS CLI credentials.

Purpose:
This allows Terraform to authenticate and create resources inside the AWS account.

Verification:

aws sts get-caller-identity

Expected Result:
Returns Account ID, User ARN, and User information.

---

# Phase 3: Network Infrastructure

## Step 3: Create Custom VPC

Created:

VPC CIDR:
10.0.0.0/16

Purpose:
A VPC provides an isolated virtual network in AWS.

Example:
Just like a company creates its own office network, AWS provides a private network environment through VPC.

Result:

VPC Name: dev-custom-vpc
CIDR: 10.0.0.0/16

---

## Step 4: Create Public Subnet

Created:

10.0.1.0/24

Purpose:
Resources requiring Internet access are placed here.

Example:
The Bastion Host was deployed inside this subnet.

Result:

Public Subnet:
10.0.1.0/24

---

## Step 5: Create Private Subnet

Created:

10.0.2.0/24

Purpose:
Sensitive resources should not be directly accessible from the Internet.

Example:
Private EC2 Server deployed inside private subnet.

Result:

Private Subnet:
10.0.2.0/24

---

## Step 6: Create Internet Gateway

Purpose:
Provides Internet connectivity to resources in public subnet.

Traffic Flow:

Internet
↓
Internet Gateway
↓
Public Subnet

Result:

Internet access enabled for Bastion Host.

---

## Step 7: Configure Route Tables

Public Route Table:

0.0.0.0/0 → Internet Gateway

Private Route Table:

Only local VPC routes

Purpose:

Controls traffic routing.

Result:

Public subnet receives Internet access.
Private subnet remains isolated.

---

# Phase 4: Security Implementation

## Step 8: Create Security Groups

### Bastion Security Group

Inbound:

SSH (22)
Source: 0.0.0.0/0

Purpose:

Allow administrators to connect from Internet.

---

### Private Server Security Group

Inbound:

SSH (22)

Source:

Bastion Security Group

Purpose:

Only Bastion Host can access Private Server.

Security Benefit:

Private Server cannot be accessed directly from Internet.

---

# Phase 5: Compute Resources

## Step 9: Launch Bastion Host

Instance Type:

t3.micro

Subnet:

Public Subnet

Purpose:

Acts as a secure jump server.

Example:

Administrator
↓
Bastion Host
↓
Private Server

Result:

Public IP assigned.

---

## Step 10: Launch Private EC2 Server

Instance Type:

t3.micro

Subnet:

Private Subnet

Purpose:

Secure application server.

Result:

No Public IP assigned.

Private IP:

10.0.2.128

---

# Phase 6: Connectivity Testing

## Step 11: SSH to Bastion Host

Command:

ssh -i dev-key.pem ec2-user@PUBLIC-IP

Purpose:

Verify external connectivity.

Result:

Successful login.

---

## Step 12: SSH to Private Server

Copied SSH key:

scp -i dev-key.pem dev-key.pem ec2-user@PUBLIC-IP:/home/ec2-user/

Connected through Bastion:

ssh -i dev-key.pem ec2-user@10.0.2.128

Purpose:

Verify secure jump-host architecture.

Result:

Successfully logged into private instance.

---

# Phase 7: Monitoring

## Step 13: Configure CloudWatch Alarms

Created alarms:

Bastion-HighCPU

PrivateServer-HighCPU

Condition:

CPU Utilization > 80%

Purpose:

Detect abnormal resource utilization.

Example:

If server CPU reaches 90%, CloudWatch triggers an alert.

---

## Step 14: Configure SNS Email Notifications

Created SNS Topic:

devsecops-alerts

Subscribed Email:

User email

Purpose:

Send alerts automatically.

Result:

Received alert emails when alarm entered ALARM state.

---

## Step 15: Test Monitoring

Installed stress tool:

sudo dnf install stress -y

Generated CPU load:

stress --cpu 2 --timeout 600

Purpose:

Simulate high CPU utilization.

Result:

CloudWatch alarm triggered successfully.

---

# Phase 8: Audit Logging

## Step 16: Configure CloudTrail

Purpose:

Record all AWS API activity.

Examples:

Create EC2
Delete VPC
Modify Security Group
IAM Changes

Result:

CloudTrail trail enabled.

Trail Name:

devsecops-trail

---

## Step 17: Store CloudTrail Logs in S3

Created:

CloudTrail S3 Bucket

Purpose:

Long-term audit storage.

Verification:

AWSLogs/
Account-ID/
CloudTrail/
Logs.json.gz

Result:

Audit logs successfully stored.

---

# Phase 9: Network Visibility

## Step 18: Configure VPC Flow Logs

Purpose:

Capture network traffic inside VPC.

Records:

Source IP
Destination IP
Port
Protocol
Accept/Reject Status

Example:

10.0.1.166 → 10.0.2.128 → Port 22 → ACCEPT

Result:

Traffic visibility enabled.

---

## Step 19: Send Flow Logs to CloudWatch

Destination:

CloudWatch Logs

Purpose:

Centralized log monitoring.

Result:

Flow log streams successfully created.

---

# Final Architecture

Internet
↓
Internet Gateway
↓
Public Subnet (10.0.1.0/24)
↓
Bastion Host
↓ SSH
Private Subnet (10.0.2.0/24)
↓
Private EC2

CloudWatch
├─ CPU Monitoring
├─ Alarms
└─ SNS Alerts

CloudTrail
└─ S3 Bucket

VPC Flow Logs
└─ CloudWatch Logs

---

# Key Skills Demonstrated

• Terraform Infrastructure as Code (IaC)
• AWS VPC Design
• Public & Private Subnet Architecture
• EC2 Deployment
• Security Groups
• Bastion Host Architecture
• CloudWatch Monitoring
• SNS Notifications
• CloudTrail Auditing
• VPC Flow Logs
• Linux Administration
• SSH Connectivity
• AWS Security Best Practices

---

# Project Outcome

Successfully designed and deployed a secure AWS DevSecOps infrastructure using Terraform. Implemented monitoring, alerting, auditing, and network traffic visibility while following security best practices such as private subnet isolation and Bastion Host access.
