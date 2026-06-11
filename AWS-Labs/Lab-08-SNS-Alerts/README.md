# Lab 08: SNS Alerts

## Objective

Deliver CloudWatch alarm notifications to an operator through an SNS email subscription.

## AWS Services Used

Amazon SNS and Amazon CloudWatch.

## Steps Performed

1. Created SNS topic `devsecops-alerts`.
2. Added an email subscription.
3. Confirmed the subscription from the recipient mailbox.
4. Connected both CloudWatch CPU alarms to the topic.
5. Triggered an alarm and verified email delivery.

```bash
aws sns list-topics
aws sns list-subscriptions-by-topic --topic-arn <topic-arn>
aws sns publish --topic-arn <topic-arn> --message "Controlled lab test"
```

## Architecture Explanation

CloudWatch publishes an alarm-state event to the SNS topic. SNS fans the notification out to confirmed subscribers, separating detection from delivery.

## Security Considerations

- Protect topic policies from unauthorized publishing or subscription.
- Avoid placing sensitive data in notifications.
- Confirm ownership of every subscription.
- Use incident routing and escalation for production workloads.

## Validation Steps

Confirm subscription status is `Confirmed`, publish a controlled test message, trigger a CloudWatch alarm, and verify the expected notification details.

## Learning Outcomes

- Implemented event-driven alert delivery.
- Distinguished alarm evaluation from notification transport.
- Tested both SNS directly and through CloudWatch.
