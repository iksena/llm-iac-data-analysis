provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

# Create Route 53 Private Hosted Zone
resource "aws_route53_zone" "private_zone" {
  name = "internal.example53.com"

  vpc {
    vpc_id = aws_vpc.main.id
  }

  tags = {
    Environment = "private"
  }
}

# Create Route 53 Record
resource "aws_route53_record" "example" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "service.internal.example53.com"
  type    = "A"
  ttl     = "300"
  records = ["10.0.0.10"]
}