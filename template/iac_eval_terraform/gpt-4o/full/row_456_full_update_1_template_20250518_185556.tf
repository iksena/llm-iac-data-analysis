The Terraform program will configure AWS as the cloud provider and set up a Virtual Private Cloud (VPC) with a CIDR block of 10.0.0.0/16. Additionally, it will create a Network Access Control List (ACL) associated with this VPC. The ACL will have specific rules to allow ingress TCP traffic from the IP range 10.3.0.0/18 on port 80 and egress TCP traffic to the IP range 10.3.0.0/18 on port 443.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Name = "main-acl"
  }
}
```

</iac_template>