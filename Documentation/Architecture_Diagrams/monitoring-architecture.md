# Monitoring Architecture

```mermaid
flowchart LR
    Bastion[Bastion EC2] -->|CPUUtilization| CW[Amazon CloudWatch]
    Private[Private EC2] -->|CPUUtilization| CW
    CW --> BA[Bastion-HighCPU Alarm]
    CW --> PA[PrivateServer-HighCPU Alarm]
    BA --> SNS[SNS Topic: devsecops-alerts]
    PA --> SNS
    SNS --> Email[Confirmed Email Subscriber]
    Operator[Cloud Operator] -->|Investigate and respond| CW
```

## Detection Logic

- Metric: `AWS/EC2 CPUUtilization`
- Statistic: average
- Period: five minutes
- Threshold: greater than 80 percent
- Action: publish to SNS

The lab validates detection by generating temporary CPU load and observing alarm state transitions and email delivery.
