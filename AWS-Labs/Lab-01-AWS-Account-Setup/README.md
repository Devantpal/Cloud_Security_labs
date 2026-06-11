# Lab 01: AWS Account Setup

## Objective

Prepare a secure AWS working environment, configure CLI access, and verify the identity and region used for the remaining labs.

## AWS Services Used

AWS IAM, AWS Management Console, AWS CLI, and AWS STS.

## Steps Performed

1. Enabled MFA for the root user and avoided routine root usage.
2. Created or selected a least-privilege administrative identity for the lab.
3. Installed AWS CLI and configured an approved profile.
4. Selected `ap-south-1` as the working region.
5. Verified the active caller before provisioning resources.

```bash
aws configure
aws sts get-caller-identity
aws configure get region
```

## Architecture Explanation

The operator authenticates through IAM and uses AWS CLI or Terraform to call AWS APIs. STS returns the caller identity, providing a critical pre-deployment check against using the wrong account or role.

## Security Considerations

- Enable MFA and protect the root account.
- Use short-lived role credentials where possible.
- Never place access keys in code, screenshots, or Git history.
- Apply least privilege and rotate credentials.
- Configure billing alerts and review CloudTrail activity.

## Validation Steps

Confirm that `aws sts get-caller-identity` returns the expected account and ARN, and that the configured region is `ap-south-1`. Verify MFA and account contact details in the console.

## Learning Outcomes

- Distinguished root, IAM user, and role-based access.
- Validated AWS identity before infrastructure deployment.
- Understood why credential hygiene is foundational to cloud security.
