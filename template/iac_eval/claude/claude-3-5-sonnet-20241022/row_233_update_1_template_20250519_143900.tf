provider "aws" {
  region = "us-west-2"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name        = "main-vpc"
    Environment = "production"
    Terraform   = "true"
  }
}

# Output the VPC ID and IPv6 CIDR block
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "vpc_ipv6_cidr" {
  value       = aws_vpc.main.ipv6_cidr_block
  description = "The IPv6 CIDR block of the VPC"
}