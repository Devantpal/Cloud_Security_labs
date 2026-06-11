# Logging Architecture

```mermaid
flowchart TB
    API[AWS API Activity] --> Trail[Multi-Region CloudTrail]
    Trail --> Bucket[S3 CloudTrail Log Bucket]
    Bucket --> Audit[Audit Review and Retention]

    VPC[VPC Network Interfaces] --> Flow[VPC Flow Logs - ALL Traffic]
    Flow --> Role[IAM Flow Logs Delivery Role]
    Role --> Group[CloudWatch Log Group: vpc-flowlogs]
    Group --> Investigation[Traffic Investigation]
```

## Log Uses

| Source | Useful For |
|---|---|
| CloudTrail | Who performed an AWS API action, when, from where, and against which resource |
| VPC Flow Logs | Source/destination analysis, port/protocol review, and accepted/rejected traffic investigation |

Production improvements include encryption, retention policies, least-privilege access, CloudTrail validation, and alerts for high-risk events.
