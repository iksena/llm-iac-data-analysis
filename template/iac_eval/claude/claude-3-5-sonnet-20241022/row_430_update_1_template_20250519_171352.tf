provider "aws" {
  region = "us-east-1"
}

# Variables
variable "environment_name" {
  description = "Name tag for all resources"
  type        = string
  default     = "dedicated-vpc"
}

# VPC Resource
resource "aws_vpc" "dedicated_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "dedicated"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.environment_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.dedicated_vpc.id

  tags = {
    Name = "${var.environment_name}-igw"
  }
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.dedicated_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.environment_name}-rt"
  }
}

# Main Route Table Association
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.dedicated_vpc.id
  route_table_id = aws_route_table.main.id
}

# Outputs
output "vpc_id" {
  value       = aws_vpc.dedicated_vpc.id
  description = "The ID of the VPC"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.main.id
  description = "The ID of the Internet Gateway"
}

output "route_table_id" {
  value       = aws_route_table.main.id
  description = "The ID of the Route Table"
}