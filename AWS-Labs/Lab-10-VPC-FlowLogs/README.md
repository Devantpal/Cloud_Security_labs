# Lab 10: VPC Flow Logs

## Objective

Capture VPC traffic metadata and send it to CloudWatch Logs for network troubleshooting and security analysis.

## AWS Services Used

Amazon VPC Flow Logs, Amazon CloudWatch Logs, and AWS IAM.

## Steps Performed

1. Created CloudWatch log group `vpc-flowlogs`.
2. Created an IAM role trusted by the VPC Flow Logs service.
3. Granted required CloudWatch Logs delivery actions.
4. Enabled Flow Logs for `ALL` VPC traffic.
5. Generated accepted and rejected traffic and reviewed records.

```bash
aws ec2 describe-flow-logs
aws logs describe-log-streams --log-group-name vpc-flowlogs
aws logs filter-log-events --log-group-name vpc-flowlogs --filter-pattern "REJECT"
```

## Architecture Explanation

VPC Flow Logs observe metadata for network interfaces in the VPC. The service assumes an IAM role and publishes records to a centralized CloudWatch log group.

## Security Considerations

- Flow Logs contain metadata, not packet payloads.
- Set log retention, encryption, access controls, and alerting.
- Narrow the delivery role permissions where possible.
- Analyze rejected traffic, unexpected ports, and unusual source addresses.

## Validation Steps

Confirm Flow Log status is active, generate known SSH traffic, locate matching records, and distinguish `ACCEPT` from `REJECT` actions.

## Learning Outcomes

- Interpreted network traffic metadata.
- Used Flow Logs to validate security-group behavior.
- Connected IAM service roles with centralized log delivery.
