# AWS DevSecOps Security Lab: Interview Questions and Answers

## Architecture and Networking

### 1. What problem does this project solve?

It demonstrates how to create a reproducible AWS environment that limits direct exposure, controls administrative access, and provides monitoring and audit evidence. Terraform builds the infrastructure while CloudWatch, SNS, CloudTrail, S3, and VPC Flow Logs provide operational and security visibility.

### 2. Why did you use a custom VPC?

A custom VPC makes network boundaries, CIDR planning, routes, and security decisions explicit. It avoids relying on permissive default-network behavior and demonstrates that I understand how workload exposure is determined.

### 3. Why separate public and private subnets?

The public subnet hosts the entry point that needs Internet reachability. The private subnet hosts the protected workload and has no Internet Gateway route, reducing its attack surface and enforcing a tiered access path.

### 4. What makes a subnet public?

A subnet is public when its associated route table has a default route to an Internet Gateway and a workload has a public address. Naming a subnet "public" alone does not make it Internet-accessible.

### 5. How is the private EC2 instance protected?

It has no public IP, resides in a subnet without an Internet default route, and uses a security group that permits SSH only from the bastion security group. These controls combine routing and stateful filtering.

### 6. What is the purpose of the bastion host?

The bastion is a controlled administrative jump point into the private tier. It reduces the number of Internet-reachable systems, but it must be tightly restricted, hardened, patched, monitored, and ideally replaced by Session Manager in production.

### 7. Why reference a security group instead of a CIDR for private SSH?

A security-group reference expresses trust in the bastion tier rather than a changing IP address. Any instance with the approved bastion security group can initiate the allowed traffic, which is easier to manage and more semantically precise.

### 8. What is the difference between a security group and a network ACL?

Security groups are stateful and apply to elastic network interfaces. Network ACLs are stateless and apply at the subnet boundary, requiring explicit rules for both directions. This project primarily uses security groups.

### 9. Why does the private route table have no Internet Gateway route?

It prevents direct Internet routing for the private workload. If controlled outbound access were required, I would evaluate NAT Gateway, VPC endpoints, proxies, and egress filtering based on the use case.

### 10. How would you make the architecture highly available?

I would deploy public and private subnets in multiple Availability Zones, use multiple managed access paths or Session Manager, place application instances behind a load balancer, and use Auto Scaling and resilient data services.

## Terraform and Automation

### 11. Why use Terraform?

Terraform makes infrastructure repeatable, reviewable, and version-controlled. Its plan workflow exposes proposed changes before execution and reduces inconsistent manual configuration.

### 12. What does `terraform init` do?

It initializes the working directory, downloads provider plugins, and configures the backend. It is required after cloning or changing provider/backend settings.

### 13. What does `terraform validate` check?

It checks syntax and internal configuration consistency. It does not prove that AWS permissions, quotas, AMI IDs, or account-specific values will work.

### 14. Why review `terraform plan`?

The plan shows proposed creates, updates, and deletions. Reviewing it helps catch unintended changes, security regressions, cost impacts, and destructive actions before they reach AWS.

### 15. What is Terraform state and why is it sensitive?

State maps Terraform resource addresses to real infrastructure and can contain IDs, attributes, and sensitive values. It should be stored in an encrypted remote backend with restricted access and locking, never committed to Git.

### 16. How would you improve this Terraform for team use?

I would parameterize account-specific values, create reusable modules, use remote state with locking, add outputs, introduce environment-specific variable files, and run formatting, validation, policy, security, and secret scans in CI.

### 17. How do Terraform dependencies work here?

References such as a subnet's `vpc_id` or an instance's security-group ID create implicit dependencies. The CloudTrail resource also uses an explicit `depends_on` because its bucket policy must exist before trail delivery is configured.

### 18. What is drift?

Drift occurs when real infrastructure differs from Terraform configuration or state, often due to manual console changes. A fresh plan helps identify it, and teams should control manual changes and reconcile intentionally.

### 19. Why pin provider versions?

Version constraints reduce unexpected behavior from provider updates and make deployments more reproducible. Teams should still test and regularly update dependencies rather than pin indefinitely.

### 20. How would you secure Terraform execution?

I would use short-lived role credentials, least-privilege permissions, protected CI environments, reviewed plans, remote encrypted state, policy-as-code, secret scanning, and approvals for production apply operations.

## Monitoring, Logging, and Response

### 21. What does CloudWatch monitor in this project?

CloudWatch evaluates EC2 `CPUUtilization` for the bastion and private server. Each alarm checks the five-minute average and publishes to SNS when CPU exceeds 80 percent.

### 22. How did you validate the alarms?

I generated temporary controlled CPU load, observed the alarm transition from `OK` to `ALARM`, confirmed the SNS notification, stopped the test, and verified recovery.

### 23. Why is CPU monitoring not enough?

CPU is only one operational signal. A mature design also monitors instance status, memory and disk through an agent, authentication failures, network anomalies, API activity, application health, log delivery, and business-specific indicators.

### 24. What is SNS doing?

SNS decouples alarm detection from notification delivery. CloudWatch publishes an alarm event to the topic, and SNS sends it to confirmed subscribers.

### 25. What does CloudTrail record?

CloudTrail records AWS API activity, including the principal, action, timestamp, source, parameters, and affected resources when available. It supports audit, investigation, and change tracking.

### 26. Why make CloudTrail multi-Region?

It improves coverage by recording supported activity across AWS Regions and includes global service events. This helps prevent visibility gaps caused by activity outside the primary workload Region.

### 27. How would you protect CloudTrail logs?

I would use a separate security account, tightly controlled bucket policy, encryption, versioning, Object Lock where appropriate, lifecycle and retention controls, log-file validation, and alerts for trail or bucket-policy changes.

### 28. What do VPC Flow Logs contain?

They contain network metadata such as source and destination addresses, ports, protocol, packet/byte counts, time window, and `ACCEPT` or `REJECT` action. They do not contain packet payloads.

### 29. How would you investigate failed SSH?

I would verify instance state and addressing, route tables, security groups, network ACLs, host firewall, SSH service, username, key permissions, and VPC Flow Logs. I would use `REJECT` records to locate network-control failures and host logs for authentication failures.

### 30. How do CloudTrail and Flow Logs complement each other?

CloudTrail explains AWS control-plane actions, while Flow Logs describe network traffic metadata. Correlating both can show that a rule changed through an API action and that network behavior changed afterward.

## IAM, Data, and Security

### 31. What is least privilege?

Least privilege grants only the actions and resources required for a task, for the required duration. It reduces blast radius if credentials or services are compromised.

### 32. How does the Flow Logs IAM role work?

The role trust policy allows the VPC Flow Logs service to assume it. Its permissions policy allows delivery actions to CloudWatch Logs. Production permissions should be narrowed to the required log resources.

### 33. What is risky about wildcard IAM resources?

Wildcards can grant access beyond the intended log group or resource. If the role is misused or a service behavior changes, broader permissions increase possible impact.

### 34. What S3 controls would you add?

I would add Block Public Access, server-side encryption, versioning, restrictive policies, lifecycle rules, access logging, retention controls, and monitoring for policy or access changes.

### 35. Why should private keys never be committed?

Anyone with the private key may authenticate as the associated identity until the key is revoked. Git history and forks make removal difficult, so exposed keys must be rotated immediately, not merely deleted from the latest commit.

### 36. Why is open SSH from `0.0.0.0/0` risky?

It exposes the SSH service to scans, brute-force attempts, and exploitation from the entire Internet. The lab documents this limitation; production should restrict source CIDRs or use Session Manager.

### 37. Why prefer Session Manager?

Session Manager can provide audited shell access without inbound SSH, public IPs, or distributed private keys. Access is controlled with IAM and can integrate with logging and session policies.

### 38. How would you handle secrets?

I would avoid secrets in code and state where possible, use AWS Secrets Manager or Systems Manager Parameter Store, grant workload roles narrow access, rotate secrets, encrypt them, and scan source control for accidental exposure.

### 39. What is defense in depth in this project?

The private workload is protected by subnet routing, absence of a public IP, security-group restrictions, controlled administrative access, monitoring, API auditing, and traffic logging. No single layer is treated as sufficient.

### 40. How would you detect malicious activity?

I would correlate CloudTrail, Flow Logs, host logs, and metrics; add GuardDuty, Security Hub, Config, and EventBridge detections; centralize logs; establish alert triage; and test response playbooks.

## Validation, Troubleshooting, and Improvement

### 41. How did you validate the network design?

I checked VPC, subnet, route-table, instance, and security-group configuration through AWS CLI and console, then tested successful bastion-mediated SSH and failed direct private access.

### 42. What would cause a private instance to be unreachable from the bastion?

Possible causes include the wrong private IP, security-group source mismatch, network ACL rules, missing local route, stopped instance, host firewall, SSH service failure, wrong username, or invalid key.

### 43. How would you reduce project cost?

I would destroy lab resources when unused, set log retention and S3 lifecycle policies, use appropriately sized instances, monitor billing, and avoid adding NAT Gateway unless required.

### 44. What was the most important design decision?

Separating the private workload from direct Internet access was central. It shaped routing, security groups, validation tests, and the need for a controlled access method.

### 45. What is one limitation of the current architecture?

The public bastion permits SSH from all IPv4 addresses in the current lab configuration. I would immediately restrict it or move to Session Manager before treating the design as production-ready.

### 46. How would you add CI/CD security?

I would run `terraform fmt -check`, `validate`, provider lock verification, Checkov or tfsec, secret detection, and policy-as-code on pull requests. Applies would use protected environments, reviewed plans, and short-lived cloud roles.

### 47. How would you test disaster recovery?

I would define recovery objectives, verify that code and protected state can reproduce infrastructure, test restoration of retained logs and data, and run controlled recovery exercises in an isolated account or Region.

### 48. How would you prove compliance?

I would map controls to evidence such as Terraform code, reviewed plans, CloudTrail records, S3 policies, Flow Logs, alarm tests, access reviews, screenshots, and documented procedures. Evidence must be protected and reproducible.

### 49. What did you learn from the project?

I learned that secure cloud design requires both preventive controls and evidence-producing detective controls. I also learned to validate assumptions through routing tests, logs, metrics, and API audit records rather than relying on resource names or diagrams.

### 50. How would you explain this project in one minute?

I built a Terraform-managed AWS security lab with a segmented VPC, a public bastion, and a private EC2 workload. I restricted private SSH to the bastion tier, added CloudWatch and SNS for detection and alerting, enabled CloudTrail to S3 for API auditing, and sent VPC Flow Logs to CloudWatch Logs for network visibility. I validated the controls through CLI queries, SSH tests, generated load, and log review, then documented production hardening priorities.
