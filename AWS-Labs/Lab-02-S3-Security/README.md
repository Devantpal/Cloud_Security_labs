# Lab 02: S3 Security

## Objective

Understand secure S3 configuration and prepare durable, controlled storage for CloudTrail audit logs.

## AWS Services Used

Amazon S3, AWS IAM, and AWS CloudTrail.

## Steps Performed

1. Reviewed S3 Block Public Access settings.
2. Created the CloudTrail log bucket through Terraform.
3. Applied a bucket policy allowing CloudTrail ACL checks and log delivery.
4. Verified CloudTrail-created objects under the `AWSLogs/` prefix.
5. Reviewed recommended encryption, versioning, retention, and lifecycle controls.

```bash
aws s3api get-public-access-block --bucket <bucket-name>
aws s3api get-bucket-policy --bucket <bucket-name>
aws s3 ls s3://<bucket-name>/AWSLogs/ --recursive
```

## Architecture Explanation

CloudTrail writes audit records to S3 using a resource policy that grants the CloudTrail service only the required bucket access. S3 acts as the durable audit destination.

## Security Considerations

- Keep log buckets private and enable all Block Public Access settings.
- Enable server-side encryption, versioning, lifecycle rules, and access logging.
- Restrict bucket policy principals and actions.
- Use separate security accounts and Object Lock for stronger production retention.

## Validation Steps

Confirm the bucket is not public, inspect the bucket policy, and verify recent compressed CloudTrail log files exist under the expected account and region prefixes.

## Learning Outcomes

- Interpreted an S3 resource policy.
- Connected S3 controls to audit-log integrity and retention.
- Identified production hardening beyond basic log delivery.
