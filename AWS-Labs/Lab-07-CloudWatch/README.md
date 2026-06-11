# Lab 07: CloudWatch Monitoring

## Objective

Monitor EC2 CPU utilization and detect abnormal resource usage with CloudWatch alarms.

## AWS Services Used

Amazon CloudWatch and Amazon EC2.

## Steps Performed

1. Created CPU alarms for the bastion and private server.
2. Configured average `CPUUtilization` over five minutes.
3. Set the alarm threshold above 80 percent.
4. Generated temporary CPU load.
5. Observed alarm state transitions.

```bash
sudo dnf install stress -y
stress --cpu 2 --timeout 600
aws cloudwatch describe-alarms --alarm-name-prefix Bastion
```

## Architecture Explanation

EC2 publishes service metrics to CloudWatch. Each alarm evaluates its instance's CPU metric and sends an action to SNS when the threshold is breached.

## Security Considerations

- Monitoring is a detection control, not a preventive control.
- Tune thresholds to avoid alert fatigue.
- Add alarms for status checks, unauthorized actions, and log-delivery failures.
- Use dashboards, retention, and encryption for operational visibility.

## Validation Steps

Confirm alarms exist with the correct instance dimensions, trigger a controlled test, observe `OK` to `ALARM` transition, and confirm recovery.

## Learning Outcomes

- Built a metric-based detection control.
- Tested alarm logic safely.
- Understood the relationship among metrics, alarms, and response actions.
