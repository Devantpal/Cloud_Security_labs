# Lab 05: Private EC2

## Objective

Deploy a private EC2 workload with no direct Internet exposure and permit administrative SSH only from the bastion tier.

## AWS Services Used

Amazon EC2, Amazon VPC, private subnet, route table, and Security Groups.

## Steps Performed

1. Created a private-instance security group.
2. Allowed TCP/22 only from the bastion security group.
3. Launched a `t3.micro` instance in the private subnet without a public IP.
4. Connected through the bastion and confirmed private-tier reachability.

```bash
ssh -J ec2-user@<bastion-public-ip> -i dev-key.pem ec2-user@<private-ip>
hostname
```

## Architecture Explanation

The private server is reachable over its private IP from the bastion. Its route table has no Internet Gateway route, and its security group trusts the bastion security group rather than an Internet CIDR.

## Security Considerations

- Avoid copying private keys to the bastion; use ProxyJump, agent forwarding with care, or Session Manager.
- Restrict outbound traffic where operationally possible.
- Use VPC endpoints for private access to AWS services.
- Patch workloads through a controlled update path.

## Validation Steps

Confirm no public IP is assigned, direct Internet SSH fails, bastion-mediated SSH succeeds, and the security-group source is the bastion security group.

## Learning Outcomes

- Protected a workload with subnet and security-group controls.
- Used security-group references for tier-to-tier access.
- Validated both permitted and denied connectivity paths.
