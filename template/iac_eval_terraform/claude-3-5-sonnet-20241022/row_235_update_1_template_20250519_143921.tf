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