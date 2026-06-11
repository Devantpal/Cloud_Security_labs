# AWS DevSecOps Security Lab

## 150-Word Project Summary

Designed and deployed a security-focused AWS environment using Terraform Infrastructure as Code. Built a custom VPC with public and private subnets across Availability Zones, explicit route tables, and an Internet Gateway. Deployed a public bastion host as the controlled administrative entry point and protected a private EC2 workload by allowing SSH only from the bastion security group. Implemented operational visibility through Amazon CloudWatch CPU alarms and SNS email notifications. Enabled multi-Region AWS CloudTrail auditing with S3 log delivery and configured VPC Flow Logs to publish accepted and rejected traffic metadata to CloudWatch Logs through an IAM service role. Validated the environment using Terraform commands, AWS CLI queries, SSH connectivity tests, generated CPU load, audit-event review, and flow-log analysis. Documented security decisions, testing evidence, troubleshooting guidance, and production hardening improvements, including Session Manager, least-privilege IAM, encrypted remote Terraform state, restricted ingress, log encryption, retention policies, CI security scanning, and secret detection.

## Technologies Used

AWS VPC, EC2, Security Groups, Internet Gateway, Route Tables, CloudWatch, SNS, CloudTrail, S3, IAM, VPC Flow Logs, Terraform, AWS CLI, Linux, SSH, Git, GitHub, Mermaid.

## ATS-Friendly Keywords

Cloud Security, AWS, DevSecOps, Infrastructure as Code, Terraform, Network Segmentation, Bastion Host, Private Subnet, Least Privilege, IAM, Security Groups, Monitoring, Alerting, Incident Detection, Audit Logging, CloudTrail, VPC Flow Logs, CloudWatch Logs, SNS, S3 Security, Linux Administration, SSH, Git, Documentation, Troubleshooting, Security Hardening.
