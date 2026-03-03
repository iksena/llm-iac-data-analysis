I'll help you create a Terraform configuration that sets up an AWS VPC with a Network ACL having specific ingress and egress rules. Here's what the configuration will do:

1. Configure AWS provider
2. Create a VPC with CIDR block 10.0.0.0/16
3. Create a Network ACL associated with the VPC
4. Define ingress rule allowing TCP traffic from 10.3.0.0/18 on port 80
5. Define egress rule allowing TCP traffic to 10.3.0.0/18 on port 443

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# Create Network ACL
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id

  # Ingress rule - Allow TCP traffic from 10.3.0.0/18 on port 80
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 80
    to_port    = 80
  }

  # Egress rule - Allow TCP traffic to 10.3.0.0/18 on port 443
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Name = "main-nacl"
  }
}
</iac_template>

This configuration creates:
1. An AWS VPC with CIDR block 10.0.0.0/16, with DNS support enabled
2. A Network ACL associated with the VPC that:
   - Allows inbound TCP traffic from 10.3.0.0/18 on port 80
   - Allows outbound TCP traffic to 10.3.0.0/18 on port 443

Note that this is a basic Network ACL configuration. In a production environment, you might want to add more rules to allow additional necessary traffic, as Network ACLs are stateless and require explicit rules for both inbound and outbound traffic. Also, by default, Network ACLs deny all traffic that isn't explicitly allowed.