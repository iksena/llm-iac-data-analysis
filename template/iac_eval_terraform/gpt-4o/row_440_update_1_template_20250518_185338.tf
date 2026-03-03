provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_egress_only_internet_gateway" "pike" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name        = "pike"
    permissions = "egress-only"
  }
}