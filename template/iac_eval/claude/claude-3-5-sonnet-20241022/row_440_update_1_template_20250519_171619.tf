provider "aws" {
  region = "us-west-2"
}

# Create VPC with IPv6 enabled
resource "aws_vpc" "main" {
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  
  tags = {
    Name = "main-vpc"
  }
}

# Create Egress-Only Internet Gateway
resource "aws_egress_only_internet_gateway" "pike" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "pike"
    permissions = "egress-only"
  }
}

# Output the ID of the created gateway
output "egress_only_internet_gateway_id" {
  value       = aws_egress_only_internet_gateway.pike.id
  description = "ID of the created Egress-Only Internet Gateway"
}