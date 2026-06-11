# Project Timeline

This timeline shows how the project progressed from foundational AWS access to automated, observable, and auditable infrastructure.

| Phase | Focus | Deliverable | Security Outcome |
|---|---|---|---|
| 1 | AWS Setup | Secure account access, CLI identity validation, and region selection | Established an authenticated and traceable working environment |
| 2 | S3 Security | Private storage concepts, access controls, and log-bucket planning | Built awareness of data protection and bucket policy risks |
| 3 | Custom VPC | `10.0.0.0/16` VPC with public and private subnets | Created network isolation boundaries |
| 4 | Public EC2 | Bastion host in the public subnet | Provided a controlled administrative entry point |
| 5 | Private EC2 | Workload without a public IP | Reduced Internet exposure |
| 6 | Bastion Host | SSH path from administrator to bastion to private server | Enforced a jump-host access pattern |
| 7 | CloudWatch | CPU metrics and threshold alarms | Added operational detection |
| 8 | SNS | Email notification channel | Enabled timely response to alarms |
| 9 | CloudTrail | Multi-Region trail with S3 delivery | Added API activity auditing |
| 10 | VPC Flow Logs | All traffic metadata delivered to CloudWatch Logs | Added network visibility and troubleshooting data |
| 11 | Terraform Automation | Reproducible Infrastructure as Code | Reduced manual drift and documented dependencies |

## Milestones

### Foundation

- Configured AWS access and verified the active identity.
- Practiced Linux and Git commands required for repeatable cloud operations.
- Reviewed S3 access-control and data-protection fundamentals.

### Secure Network Build

- Created an isolated VPC.
- Separated public and private workloads into different subnets and Availability Zones.
- Connected only the public subnet to an Internet Gateway.
- Used security-group references to allow private SSH only from the bastion tier.

### Detection and Audit

- Added CloudWatch alarms for abnormal EC2 CPU utilization.
- Connected alarms to an SNS email topic.
- Enabled CloudTrail for API auditing and S3 delivery.
- Enabled VPC Flow Logs for accepted and rejected traffic visibility.

### Automation and Portfolio Documentation

- Represented infrastructure as Terraform resources.
- Validated resources and recorded evidence.
- Documented deployment, testing, security decisions, lessons learned, and future hardening work.
