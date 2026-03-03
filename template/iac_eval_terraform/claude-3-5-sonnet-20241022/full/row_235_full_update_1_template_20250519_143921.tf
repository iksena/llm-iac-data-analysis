I'll help you create a Terraform configuration to set up an AWS VPC with an Egress-Only Internet Gateway. This configuration will:

1. Create a VPC with IPv6 CIDR block (required for Egress-Only Internet Gateway)
2. Create an Egress-Only Internet Gateway and attach it to the VPC
3. Create a route table with a route for IPv6 traffic through the Egress-Only Internet Gateway
4. Include necessary provider configuration

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
    Name = "main-vpc"
  }
}

# Create Egress-Only Internet Gateway
resource "aws_egress_only_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-eigw"
  }
}

# Create Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.main.id
  }

  tags = {
    Name = "main-rt"
  }
}

# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}

# Output the Egress-Only Internet Gateway ID
output "eigw_id" {
  value = aws_egress_only_internet_gateway.main.id
}

# Output the VPC IPv6 CIDR block
output "vpc_ipv6_cidr" {
  value = aws_vpc.main.ipv6_cidr_block
}
</iac_template>

This Terraform configuration creates:
1. An AWS VPC with both IPv4 (10.0.0.0/16) and an automatically assigned IPv6 CIDR block
2. An Egress-Only Internet Gateway attached to the VPC
3. A route table with a route for all IPv6 traffic (::/0) through the Egress-Only Internet Gateway
4. Appropriate outputs for reference

The Egress-Only Internet Gateway is specifically designed for IPv6 traffic and allows instances in the VPC to initiate outbound connections over IPv6 while preventing inbound connections. This is similar to how a NAT Gateway works for IPv4 traffic.

All resources are properly tagged for better resource management and identification. The configuration uses the us-west-2 region, but you can modify this as needed.