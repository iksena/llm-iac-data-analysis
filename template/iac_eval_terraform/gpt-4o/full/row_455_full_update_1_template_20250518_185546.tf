The Terraform program will define a default network ACL (Access Control List) in an AWS VPC. This ACL will have rules that allow all inbound and outbound traffic from any source and to any destination. The configuration will include the necessary provider setup for AWS and will create a VPC if one does not already exist. The network ACL will be associated with the VPC, and the rules will be set to allow all traffic.

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

resource "aws_network_acl" "default" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "default-acl"
  }
}
```
</iac_template>

This configuration sets up a VPC and a network ACL with rules that allow all traffic. The `protocol` is set to `-1`, which means all protocols are allowed. The `cidr_block` is set to `0.0.0.0/0`, allowing traffic from and to any IP address. The `from_port` and `to_port` are set to `0`, which is a wildcard for all ports. The `rule_no` is set to `100`, which is a common practice for default rules.