# Terraform Deployment Guide

This directory provisions the AWS DevSecOps Security Lab in `ap-south-1` using Terraform 1.5+ and the HashiCorp AWS provider 5.x.

## What It Deploys

- VPC: `10.0.0.0/16`
- Public subnet: `10.0.1.0/24` in `ap-south-1a`
- Private subnet: `10.0.2.0/24` in `ap-south-1b`
- Internet Gateway and public/private route tables
- Bastion host and private EC2 instance
- Bastion and private-instance security groups
- CloudWatch CPU alarms and SNS email notifications
- Multi-Region CloudTrail and S3 log bucket
- VPC Flow Logs, CloudWatch log group, and IAM delivery role

## Prerequisites

- Terraform 1.5 or later
- AWS CLI with an authorized profile
- An existing EC2 key pair named `dev-key`
- Permissions to manage the AWS resources listed above
- A unique S3 bucket name and a valid SNS email endpoint

Verify the active AWS identity before deployment:

```bash
aws sts get-caller-identity
```

## Provider Configuration

`providers.tf` pins Terraform to version `>= 1.5.0`, selects the AWS provider at `~> 5.0`, and configures the `ap-south-1` region. Authentication is expected to come from the standard AWS credential chain, such as an AWS CLI profile, environment variables, or an attached role.

Do not hard-code AWS access keys in Terraform files.

## Core Workflow

### Initialize

```bash
terraform init
```

Downloads the required provider plugins, initializes the working directory, and prepares the configured backend. Run this after cloning the repository or changing provider/backend settings.

### Format

```bash
terraform fmt -check
```

Checks whether Terraform files follow canonical formatting. Use `terraform fmt` to apply formatting when needed.

### Validate

```bash
terraform validate
```

Checks Terraform syntax and internal configuration consistency. Validation does not confirm that AWS permissions, AMI IDs, or account-specific values are correct.

### Plan

```bash
terraform plan -out=tfplan
```

Compares the configuration with the current state and shows proposed creates, updates, and deletions. Review every action before applying it. The optional `-out=tfplan` saves the reviewed plan.

### Apply

```bash
terraform apply tfplan
```

Executes the saved plan. Without a saved plan, use `terraform apply` and review the generated plan before approving.

### Inspect State

```bash
terraform state list
```

Lists resources tracked in Terraform state. This is useful for confirming managed resources and troubleshooting drift. State can contain sensitive values and must not be committed to source control.

### Show Outputs

```bash
terraform output
```

Displays configured output values. This project currently has no declared outputs, so add outputs in a future iteration for useful connection details while avoiding secrets.

### Destroy

```bash
terraform destroy
```

Plans and removes resources managed by this configuration. Review the destroy plan carefully, confirm required evidence and logs have been retained, then approve to prevent unnecessary cost.

## Validation Checklist

```bash
terraform fmt -check
terraform validate
terraform plan
terraform state list
aws ec2 describe-vpcs --filters Name=tag:Name,Values=dev-custom-vpc
aws cloudtrail get-trail-status --name devsecops-trail
aws logs describe-log-groups --log-group-name-prefix vpc-flowlogs
```

Also confirm the SNS subscription from the destination email address before testing alarms.

## Security Considerations

- Restrict bastion SSH to an approved source CIDR; `0.0.0.0/0` is not suitable for production.
- Prefer Systems Manager Session Manager to reduce key and inbound-port exposure.
- Never commit `*.pem`, credentials, plans, or `terraform.tfstate`.
- Store production state in an encrypted remote backend with locking and tightly controlled access.
- Enable S3 encryption, Block Public Access, versioning, lifecycle rules, and appropriate retention.
- Add CloudWatch Logs retention and encryption.
- Replace wildcard IAM resources with the narrowest required ARNs.
- Parameterize account-specific values and keep notification endpoints out of shared code.

## Troubleshooting

| Symptom | Check |
|---|---|
| Authentication error | Run `aws sts get-caller-identity` and verify the active profile |
| Invalid AMI | Confirm the AMI exists in `ap-south-1` |
| Key pair error | Confirm `dev-key` exists in the selected region |
| S3 bucket conflict | Choose a globally unique bucket name |
| No SNS email | Confirm the pending subscription email |
| No Flow Logs | Check IAM trust/policy, log group, and flow-log status |
| Private SSH fails | Check security-group references, username, key permissions, and routing |

## Cost Control

Review the AWS Pricing pages for current costs. Destroy resources after the lab and verify that EC2 instances, log groups, SNS topics, CloudTrail configuration, and S3 objects no longer generate unwanted charges.
