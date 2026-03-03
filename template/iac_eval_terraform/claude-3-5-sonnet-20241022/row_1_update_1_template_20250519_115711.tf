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

# Create Private Hosted Zone
resource "aws_route53_zone" "private" {
  name = "example.internal"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = {
    Environment = "private"
  }
}

# Create Zone Association
resource "aws_route53_zone_association" "private" {
  zone_id = aws_route53_zone.private.id
  vpc_id  = aws_vpc.main.id
}

# Output the Zone ID
output "zone_id" {
  value = aws_route53_zone.private.id
}

# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}