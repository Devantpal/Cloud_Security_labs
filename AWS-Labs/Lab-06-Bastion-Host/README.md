# Lab 06: Bastion Host

## Objective

Validate a jump-host access pattern from an administrator workstation to a private EC2 instance.

## AWS Services Used

Amazon EC2, Amazon VPC, Security Groups, and VPC Flow Logs.

## Steps Performed

1. Confirmed SSH access to the public bastion.
2. Used the bastion as an SSH jump host to reach the private server.
3. Verified that the private server rejected direct Internet access.
4. Reviewed flow logs for the bastion-to-private SSH connection.

```bash
ssh -i dev-key.pem ec2-user@<bastion-public-ip>
ssh -J ec2-user@<bastion-public-ip> -i dev-key.pem ec2-user@<private-ip>
```

## Architecture Explanation

The bastion crosses the boundary between the public administrative entry point and private workload tier. Security-group chaining allows only bastion-originated SSH to the private server.

## Security Considerations

- Limit source addresses, enforce MFA-backed access, and log sessions.
- Avoid long-lived SSH keys and key duplication.
- Harden and patch the bastion because it is exposed.
- Prefer Session Manager for production environments.

## Validation Steps

Test successful bastion SSH, successful private SSH through the bastion, failed direct private SSH, and expected `ACCEPT`/`REJECT` records in Flow Logs.

## Learning Outcomes

- Explained the purpose and limitations of a bastion architecture.
- Tested positive and negative network paths.
- Connected access controls with network telemetry.
