provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "example-vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.example_vpc.id
}

output "ipv6_cidr_block" {
  value = aws_vpc.example_vpc.ipv6_cidr_block
}