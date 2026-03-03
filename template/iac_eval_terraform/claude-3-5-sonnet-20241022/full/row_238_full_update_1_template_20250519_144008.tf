I'll help you create a Terraform configuration that sets up two VPCs in AWS and establishes a VPC peering connection between them. The configuration will include:

1. Two VPCs in different CIDR ranges
2. Subnets in each VPC
3. Route tables for each VPC
4. A VPC peering connection
5. Route table entries to enable communication through the peering connection

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables with default values
variable "vpc_1_cidr" {
  description = "CIDR block for first VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_2_cidr" {
  description = "CIDR block for second VPC"
  default     = "172.16.0.0/16"
}

# First VPC
resource "aws_vpc" "vpc_1" {
  cidr_block           = var.vpc_1_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC-1"
  }
}

# Second VPC
resource "aws_vpc" "vpc_2" {
  cidr_block           = var.vpc_2_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC-2"
  }
}

# Subnet for VPC-1
resource "aws_subnet" "vpc_1_subnet" {
  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "VPC-1 Subnet"
  }
}

# Subnet for VPC-2
resource "aws_subnet" "vpc_2_subnet" {
  vpc_id     = aws_vpc.vpc_2.id
  cidr_block = "172.16.1.0/24"

  tags = {
    Name = "VPC-2 Subnet"
  }
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id = aws_vpc.vpc_2.id
  vpc_id      = aws_vpc.vpc_1.id
  auto_accept = true

  tags = {
    Name = "VPC Peering between VPC-1 and VPC-2"
  }
}

# Route Table for VPC-1
resource "aws_route_table" "vpc_1_rt" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block                = var.vpc_2_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  }

  tags = {
    Name = "VPC-1 Route Table"
  }
}

# Route Table for VPC-2
resource "aws_route_table" "vpc_2_rt" {
  vpc_id = aws_vpc.vpc_2.id

  route {
    cidr_block                = var.vpc_1_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  }

  tags = {
    Name = "VPC-2 Route Table"
  }
}

# Route Table Association for VPC-1
resource "aws_route_table_association" "vpc_1_rta" {
  subnet_id      = aws_subnet.vpc_1_subnet.id
  route_table_id = aws_route_table.vpc_1_rt.id
}

# Route Table Association for VPC-2
resource "aws_route_table_association" "vpc_2_rta" {
  subnet_id      = aws_subnet.vpc_2_subnet.id
  route_table_id = aws_route_table.vpc_2_rt.id
}
</iac_template>

This Terraform configuration creates:
1. Two VPCs with different CIDR ranges (10.0.0.0/16 and 172.16.0.0/16)
2. One subnet in each VPC
3. A VPC peering connection between the two VPCs
4. Route tables for each VPC with routes to enable communication through the peering connection
5. Route table associations with the respective subnets

The configuration uses the us-east-1 region and includes all necessary resources for a working VPC peering setup. The VPCs will be able to communicate with each other through the peering connection once deployed.

Key features:
- VPC-1 uses CIDR 10.0.0.0/16 with a subnet of 10.0.1.0/24
- VPC-2 uses CIDR 172.16.0.0/16 with a subnet of 172.16.1.0/24
- Auto-accept is enabled for the VPC peering connection
- DNS support and DNS hostnames are enabled for both VPCs
- Route tables are configured to route traffic between the VPCs through the peering connection