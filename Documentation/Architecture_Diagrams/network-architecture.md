# Network Architecture

```mermaid
flowchart LR
    User[Administrator] -->|SSH TCP 22| Internet[Internet]
    Internet --> IGW[Internet Gateway]

    subgraph VPC["VPC 10.0.0.0/16"]
        subgraph Public["Public Subnet 10.0.1.0/24 - ap-south-1a"]
            Bastion[Bastion Host<br/>Public IP]
        end

        subgraph Private["Private Subnet 10.0.2.0/24 - ap-south-1b"]
            Server[Private EC2<br/>No Public IP]
        end

        Bastion -->|SSH allowed by bastion SG reference| Server
    end

    IGW --> Public
```

## Design Notes

- The public route table sends `0.0.0.0/0` to the Internet Gateway.
- The private route table contains no Internet default route.
- The private security group accepts SSH only from the bastion security group.
- Production hardening should restrict bastion ingress or replace it with Session Manager.
