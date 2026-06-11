# Lab 03: Custom VPC

## Objective

Build a segmented AWS network with separate public and private subnets and explicit routing.

## AWS Services Used

Amazon VPC, subnets, route tables, and Internet Gateway.

## Steps Performed

1. Created VPC `10.0.0.0/16`.
2. Created public subnet `10.0.1.0/24` in `ap-south-1a`.
3. Created private subnet `10.0.2.0/24` in `ap-south-1b`.
4. Attached an Internet Gateway.
5. Routed public `0.0.0.0/0` traffic to the gateway.
6. Associated the private subnet with an isolated private route table.

```bash
aws ec2 describe-vpcs --filters Name=tag:Name,Values=dev-custom-vpc
aws ec2 describe-subnets --filters Name=vpc-id,Values=<vpc-id>
aws ec2 describe-route-tables --filters Name=vpc-id,Values=<vpc-id>
```

## Architecture Explanation

The public subnet has a route to the Internet Gateway. The private subnet has only VPC-local routing, so its workloads cannot be reached directly from the Internet.

## Security Considerations

- Use subnet segmentation to separate trust zones.
- Add controlled outbound connectivity only when required.
- Use network ACLs as an optional stateless boundary, while keeping security groups primary.
- Plan CIDR ranges to avoid overlap with connected networks.

## Validation Steps

Confirm CIDR blocks, Availability Zones, route-table associations, and the absence of a private-subnet Internet default route.

## Learning Outcomes

- Designed a basic multi-tier VPC.
- Distinguished subnet classification from instance public-IP assignment.
- Connected route-table behavior to workload exposure.
