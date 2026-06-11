# Lab 04: Public EC2

## Objective

Deploy and validate a bastion EC2 instance in the public subnet as the controlled entry point to the private tier.

## AWS Services Used

Amazon EC2, Amazon VPC, Security Groups, and Internet Gateway.

## Steps Performed

1. Created a bastion security group.
2. Launched a `t3.micro` instance in the public subnet.
3. Associated a public IP and the `dev-key` EC2 key pair.
4. Connected through SSH and confirmed instance identity.

```bash
chmod 400 dev-key.pem
ssh -i dev-key.pem ec2-user@<bastion-public-ip>
hostname
```

## Architecture Explanation

The bastion resides in the subnet routed to the Internet Gateway. It provides the administrative hop to the private EC2 instance, while the private instance remains without a public IP.

## Security Considerations

- The lab configuration allows SSH from `0.0.0.0/0`; restrict this to a trusted CIDR before production use.
- Prefer Session Manager to eliminate inbound SSH and private-key handling.
- Patch, monitor, and minimize software on bastion hosts.
- Do not store private keys on the bastion.

## Validation Steps

Confirm the instance is running in the public subnet, has the correct security group and public IP, and accepts SSH only as intended.

## Learning Outcomes

- Deployed and connected to an EC2 instance.
- Understood the role and risk of a bastion host.
- Identified safer production alternatives to Internet-facing SSH.
