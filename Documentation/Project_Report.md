# AWS DevSecOps Security Lab Project Report

## Introduction

Cloud infrastructure must be more than functional. It must also limit exposure, produce useful security evidence, support repeatable deployment, and make abnormal behavior visible to operators. This project demonstrates those principles through a practical AWS DevSecOps security lab built with Terraform. The environment combines network segmentation, controlled administrative access, monitoring, automated alerting, API auditing, and network traffic logging.

The project is designed as both a technical implementation and a professional portfolio artifact. It shows how AWS resources work together, how Infrastructure as Code improves repeatability, and how security controls should be validated rather than merely configured. The repository includes ten guided AWS labs, Linux and Git reference material, architecture diagrams, deployment documentation, screenshot checklists, resume content, and interview preparation.

The deployed environment uses a custom Amazon VPC with a public subnet and a private subnet. A bastion EC2 instance is placed in the public subnet, while a private EC2 workload is placed in the isolated private subnet without a public IP address. Security groups permit the private server to receive SSH only from the bastion security group. CloudWatch monitors EC2 CPU utilization, and SNS delivers email notifications when configured thresholds are breached. CloudTrail records AWS API activity and delivers logs to S3. VPC Flow Logs capture network traffic metadata and publish it to CloudWatch Logs through an IAM service role.

This is a learning environment rather than a production blueprint. The implementation intentionally provides opportunities to identify and discuss hardening work. Examples include restricting public SSH, replacing bastion access with AWS Systems Manager Session Manager, protecting Terraform state, encrypting and retaining logs, narrowing IAM permissions, and adding automated security checks.

## Objective

The main objective was to design, deploy, validate, and document an AWS environment that demonstrates foundational cloud security and DevSecOps skills. The project needed to show an understanding of preventive controls, detective controls, automation, and evidence.

The technical objectives were:

- Provision AWS resources consistently with Terraform.
- Create a segmented network with distinct public and private trust zones.
- Prevent direct Internet access to the private EC2 workload.
- Provide a controlled administrative path through a bastion host.
- Monitor EC2 resource usage and generate automated alerts.
- Record AWS API activity for audit and investigation.
- Capture VPC traffic metadata for network analysis.
- Validate each control with commands, connectivity tests, logs, and screenshots.
- Document limitations and propose production improvements.

The portfolio objective was equally important. A cloud security engineer must communicate architecture, operational procedures, risks, and evidence clearly. For that reason, the repository is structured so a reviewer can quickly understand what was built, why decisions were made, how controls were tested, and what would change in production.

## Architecture

The network uses a VPC with CIDR block `10.0.0.0/16`. A public subnet, `10.0.1.0/24`, is deployed in `ap-south-1a`. A private subnet, `10.0.2.0/24`, is deployed in `ap-south-1b`. Using different Availability Zones demonstrates separation and provides a foundation for future high-availability improvements.

An Internet Gateway is attached to the VPC. The public route table contains a default route, `0.0.0.0/0`, pointing to the Internet Gateway and is associated with the public subnet. The private subnet is associated with a separate private route table that has no Internet default route. This routing design means that placing an instance in the private subnet does not provide it with direct Internet connectivity.

The public subnet hosts the bastion EC2 instance. The instance has a public IP address and acts as the administrative entry point. The private subnet hosts the private EC2 server, which has no public IP address. An administrator first connects to the bastion and then reaches the private server over its private address. In a stronger implementation, the administrator would use SSH ProxyJump without copying a key to the bastion, or would replace SSH with Session Manager.

Two security groups implement stateful filtering. The bastion security group permits inbound SSH. In the current lab configuration, the source is `0.0.0.0/0`, which is useful for initial connectivity testing but is not appropriate for production. The private security group permits inbound SSH only when the source is the bastion security group. This use of a security-group reference establishes trust between tiers without relying on a fixed bastion private IP address.

The monitoring architecture connects each EC2 instance to a CloudWatch CPU alarm. When average CPU utilization exceeds 80 percent during a five-minute evaluation period, the alarm publishes to an SNS topic. A confirmed email subscription receives the alert. This demonstrates an event-driven path from metric collection to operator notification.

The logging architecture has two major paths. CloudTrail records control-plane activity and sends it to an S3 bucket. VPC Flow Logs capture network metadata for all traffic and deliver it to a CloudWatch log group through an IAM role. Together, these sources support investigations that need both API-change history and network behavior.

## AWS Services

### Amazon VPC

Amazon VPC provides the isolated network boundary for the project. It contains the subnets, route tables, Internet Gateway attachment, security groups, instances, and Flow Logs configuration. The VPC is the basis for understanding how AWS networking choices affect exposure and reachability.

### Amazon EC2

Two `t3.micro` EC2 instances provide the compute layer. The bastion host represents a controlled entry point, while the private instance represents a protected application or administrative workload. Their placement and security-group relationships are more important to the security design than the applications running on them.

### Security Groups

Security groups provide stateful instance-level traffic filtering. The private security group accepts SSH from the bastion security group, not from the Internet. This pattern demonstrates how security-group references can define communication between application tiers.

### Amazon CloudWatch

CloudWatch provides metric monitoring, alarm evaluation, and centralized log storage. In this project, it monitors EC2 CPU utilization and stores VPC Flow Logs. CloudWatch helps transform infrastructure from a collection of deployed resources into an observable environment.

### Amazon SNS

SNS provides the alert delivery channel. Both CPU alarms publish to a shared topic, and a confirmed email subscription receives notifications. Decoupling alarms from destinations makes it possible to add other subscribers or integrations later.

### AWS CloudTrail

CloudTrail provides control-plane audit visibility. It answers questions such as who made an API call, which action was performed, when it occurred, and where it originated. The configured trail is multi-Region, includes global service events, and actively delivers logs.

### Amazon S3

S3 stores CloudTrail audit records. A bucket policy grants the CloudTrail service the permissions required to check the bucket ACL and write log objects. For production use, the bucket should receive additional protection such as encryption, versioning, strict Block Public Access, lifecycle rules, retention controls, and tightly limited human access.

### AWS IAM

IAM allows the VPC Flow Logs service to assume a delivery role and publish to CloudWatch Logs. This demonstrates the difference between a role trust policy, which controls who can assume the role, and a permissions policy, which controls what the assumed role can do.

### VPC Flow Logs

VPC Flow Logs capture network metadata such as source address, destination address, ports, protocol, packet and byte counts, and whether traffic was accepted or rejected. They do not capture packet contents. Flow Logs are useful for validating network controls, investigating connectivity problems, and identifying unusual patterns.

## Terraform

Terraform is used to represent the environment as Infrastructure as Code. The AWS provider configuration requires Terraform 1.5 or later, selects the HashiCorp AWS provider version 5.x, and targets the `ap-south-1` region.

The Terraform workflow begins with `terraform init`, which initializes the directory and downloads providers. `terraform fmt -check` verifies canonical formatting. `terraform validate` checks syntax and internal consistency. `terraform plan` compares the desired configuration with state and AWS, showing the actions Terraform proposes. A plan must be reviewed for unintended changes, security regressions, cost impact, and destructive actions before `terraform apply` executes it.

Resource references create dependency relationships. For example, subnets reference the VPC ID, instances reference subnet and security-group IDs, alarms reference EC2 instance IDs, and Flow Logs reference the IAM role and log group. Terraform uses this dependency graph to determine a safe creation order. CloudTrail includes an explicit dependency on its bucket policy because AWS log delivery requires that policy to be available.

Terraform state is a critical security concern. State maps Terraform resource addresses to real resources and can contain sensitive attributes. A professional team should not store state in Git or rely on an unprotected local state file. A production implementation would use an encrypted remote backend, locking, versioning, access controls, and backup/recovery procedures. Plans and crash logs should also be handled carefully because they may contain sensitive data.

Additional Terraform improvements include parameterizing hard-coded values, separating environments, creating modules, adding outputs, narrowing IAM policy resources, adding tags, and implementing automated checks. CI should run formatting, validation, provider lock checks, static security analysis such as Checkov or tfsec, policy-as-code, and secret detection. Apply operations should use short-lived roles and protected environments.

## Monitoring

Monitoring helps operators identify abnormal conditions before they become larger incidents. This project creates one CloudWatch CPU alarm for each EC2 instance. The alarms evaluate average `CPUUtilization` over a five-minute period and enter the `ALARM` state when the value exceeds 80 percent. The action publishes to the SNS topic.

The alarm path is validated by generating temporary CPU load on an instance. A tool such as `stress` can create a controlled condition that pushes utilization above the threshold. During the test, the operator observes the CloudWatch metric, verifies the alarm transition, confirms email notification, stops the load, and verifies that the alarm returns to `OK`.

This test is important because a configured alarm is not automatically a reliable alarm. Common failures include an unconfirmed SNS subscription, the wrong instance dimension, a threshold that never triggers, missing data behavior, or a notification policy problem. Controlled testing produces evidence that the end-to-end detection path works.

CPU monitoring alone is not sufficient for production. Future monitoring should include EC2 status checks, disk and memory metrics through the CloudWatch agent, log-delivery health, authentication failures, high-risk API events, unusual network patterns, application health, and business-specific service-level indicators. Alarm severity, escalation paths, ownership, and response procedures should also be documented.

## Logging

Logging supports troubleshooting, security investigation, compliance evidence, and incident response. The project implements both API auditing and network telemetry.

CloudTrail records AWS API activity. It provides context about identities, actions, timestamps, source addresses, request parameters, and affected resources. This data can reveal configuration changes, security-group modifications, resource creation, logging changes, and suspicious account activity. The multi-Region setting helps avoid blind spots outside the primary deployment Region.

CloudTrail logs are delivered to S3 for durable storage. Production controls should protect these logs from unauthorized access, modification, and deletion. Recommended measures include encryption, versioning, Object Lock where required, log-file validation, lifecycle management, restricted bucket policies, and centralized storage in a dedicated security account. Alerts should detect attempts to stop logging or change trail and bucket policies.

VPC Flow Logs provide a different view. They show traffic metadata rather than AWS API actions. For example, a Flow Log record can help determine whether SSH traffic from the bastion to the private instance was accepted or rejected. Rejected traffic may indicate a security-group, network ACL, or routing problem, while accepted traffic combined with failed host authentication points the investigation toward the operating system or credentials.

Flow Logs are delivered to a CloudWatch log group through an IAM role. Production improvements should include log retention, encryption, access controls, subscription filters, and detections for unusual sources, unexpected ports, repeated rejected connections, and suspicious traffic volume.

The strongest investigations correlate multiple sources. A CloudTrail record might show that a security group was changed, Flow Logs might show newly accepted traffic afterward, and Linux logs might show failed authentication attempts from the new source. Correlation converts independent records into a defensible incident timeline.

## Security

The project applies defense in depth by combining network isolation, stateful filtering, controlled access, monitoring, alerting, API auditing, and network logging. The private server is not protected by only one control. It lacks a public IP, resides behind a private route table, accepts SSH only from the bastion security group, and is covered by monitoring and logging.

The most important documented risk is the bastion security group's SSH rule from `0.0.0.0/0`. This makes the SSH service visible to the entire Internet. For production, the source should be restricted to a trusted administrator CIDR at minimum. A better approach is Session Manager, which can provide audited access without inbound SSH, public IP addresses, or distributed private keys.

Private-key handling is another major concern. Private keys must never be committed to Git, included in screenshots, or copied unnecessarily between systems. If a key is exposed, deleting it from the latest commit is not enough because it may remain in history, forks, caches, or logs. The key must be revoked or replaced immediately, and history remediation should follow organizational procedures.

IAM permissions should follow least privilege. The Flow Logs role currently demonstrates the required delivery actions, but production policies should narrow resources and actions to the smallest practical set. Human users should use MFA and short-lived roles. Root credentials should be protected and not used for everyday work.

Data protection should include encryption and retention. CloudTrail S3 objects and CloudWatch logs should be encrypted with appropriate key policies. S3 versioning, lifecycle policies, and potentially Object Lock can protect audit evidence. Log retention should balance investigation and compliance needs with cost.

DevSecOps improvements should shift checks earlier. Pull requests should be scanned for secrets, Terraform misconfigurations, formatting problems, risky policy changes, and unapproved resources. Branch protection and review requirements should prevent unreviewed infrastructure changes. Deployment roles should be separate from developer identities and should use short-lived credentials.

## Testing

Testing verifies that intended controls work and unintended paths fail. This project uses configuration inspection, command-line validation, connectivity testing, generated load, and log review.

Terraform testing begins with formatting, validation, and plan review. After deployment, AWS CLI commands verify the caller identity, VPC, subnets, route tables, EC2 instances, security groups, alarms, trail status, log groups, and flow-log status. Console screenshots provide visual evidence, but CLI output is especially useful because it is repeatable and precise.

Network testing includes both positive and negative cases. The administrator should be able to reach the bastion through the approved method. The bastion should be able to reach the private server over SSH. A direct Internet connection to the private server should fail. Flow Logs should reflect expected accepted and rejected paths.

Monitoring testing generates controlled CPU load and verifies the entire chain from EC2 metric to CloudWatch alarm to SNS email. After the load stops, the alarm should recover. Testing should be performed carefully to avoid destabilizing unrelated resources.

Audit testing performs controlled AWS API actions and confirms that CloudTrail Event History and delivered S3 log objects contain the expected evidence. Network logging testing generates known connections and searches CloudWatch Logs for matching records. These tests demonstrate not only that resources exist, but also that they produce useful evidence.

Destructive and recovery testing should be handled deliberately. `terraform destroy` is used to remove lab resources and control cost after evidence has been captured. A mature implementation would also test state recovery, infrastructure recreation, retained log access, and incident-response procedures in an isolated environment.

## Challenges

One challenge is understanding that AWS resource names do not define security behavior. A subnet named "private" is not private unless its routes and instance addressing support that design. Similarly, a security group named "bastion" is not secure unless its rules are appropriately restricted. The project addresses this by validating actual routes, addresses, rules, and connection outcomes.

Another challenge is troubleshooting across layers. A failed SSH connection can result from addressing, routing, security groups, network ACLs, operating-system firewalls, the SSH daemon, usernames, keys, or permissions. Effective troubleshooting requires a structured process that checks each layer and uses Flow Logs and host logs to narrow the cause.

Alerting presents a different challenge: configuration does not guarantee delivery. An SNS email subscription must be confirmed, and a CloudWatch alarm must reference the correct metric and instance. Controlled tests are necessary to prove the end-to-end path and tune thresholds.

Logging introduces policy and retention complexity. CloudTrail requires an S3 policy that allows the service to verify and write to the bucket. VPC Flow Logs require an IAM role and CloudWatch Logs permissions. Overly broad permissions simplify early learning but must be narrowed for production. Logs must also be protected from deletion and unauthorized access while remaining available to investigators.

Terraform state and account-specific values create source-control risks. State, private keys, credentials, notification endpoints, account IDs, and globally unique bucket names require careful handling. The documentation explicitly highlights these concerns so that the portfolio shows security judgment, not only successful deployment.

## Conclusion

The AWS DevSecOps Security Lab demonstrates how network design, Infrastructure as Code, monitoring, alerting, audit logging, and network telemetry combine to create a more secure and observable cloud environment. Terraform provides repeatability and a reviewable description of infrastructure. The custom VPC and security groups reduce direct exposure. CloudWatch and SNS support operational detection and notification. CloudTrail and S3 provide an API audit trail, while VPC Flow Logs and CloudWatch Logs provide network visibility.

The project also demonstrates an essential engineering habit: controls must be tested. Successful deployment is only the beginning. Connectivity tests verify segmentation, generated load verifies alarm behavior, API activity verifies audit delivery, and Flow Log review verifies network telemetry. Documenting negative tests and limitations makes the result more credible.

Before production use, the design should be hardened by eliminating open SSH, adopting Session Manager, protecting keys and state, encrypting and retaining logs, centralizing security evidence, narrowing IAM permissions, adding high availability, and integrating automated security checks into CI/CD. These improvements are not hidden weaknesses; they are a roadmap that shows the ability to assess risk and evolve a learning implementation into a professional cloud security platform.
