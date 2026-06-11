# Resume Bullet Points

- Designed and provisioned a security-focused AWS environment with Terraform, integrating VPC, EC2, IAM, CloudWatch, SNS, CloudTrail, S3, and VPC Flow Logs.
- Built a segmented `10.0.0.0/16` VPC with separate public and private subnets across two Availability Zones and explicit route-table associations.
- Reduced workload exposure by deploying a private EC2 instance without a public IP and permitting SSH only from a bastion security group.
- Implemented a controlled bastion-host access path and validated allowed and denied network flows through SSH tests and VPC Flow Logs.
- Configured CloudWatch CPU alarms for two EC2 instances and automated incident notifications through a confirmed SNS email subscription.
- Enabled multi-Region CloudTrail auditing with S3 log delivery to improve visibility into AWS API activity and support investigations.
- Centralized VPC network telemetry in CloudWatch Logs through an IAM service role and analyzed `ACCEPT` and `REJECT` traffic records.
- Applied Infrastructure as Code workflows using `terraform init`, `validate`, `plan`, `apply`, state inspection, and controlled resource destruction.
- Produced detailed security documentation, architecture diagrams, validation checklists, troubleshooting guidance, and interview-ready project narratives.
- Identified and documented production hardening priorities including restricted ingress, Session Manager, least-privilege IAM, encrypted remote state, retention controls, and CI security scanning.
