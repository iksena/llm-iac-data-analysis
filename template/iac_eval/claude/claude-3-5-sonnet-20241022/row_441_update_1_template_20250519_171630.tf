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

# Create Subnet with IPv6 support
resource "aws_subnet" "private" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = "10.0.1.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true
  availability_zone               = "us-west-2a"

  tags = {
    Name = "private-subnet"
  }
}

# Create Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.main.id
  }

  tags = {
    Name = "private-rt"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Output Values
output "vpc_id" {
  value = aws_vpc.main.id
}

output "egress_only_internet_gateway_id" {
  value = aws_egress_only_internet_gateway.main.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}