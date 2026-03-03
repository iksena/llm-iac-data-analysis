provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_route53_zone" "private_zone" {
  name          = "internal.example53.com"
  comment       = "Private hosted zone for internal use"
  private_zone  = true

  vpc {
    vpc_id     = aws_vpc.main.id
    vpc_region = "us-east-1"
  }
}

resource "aws_route53_record" "non_alias_record" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "app.internal.example53.com"  # Fully qualified name for the record
  type    = "A"
  ttl     = 300
  records = ["10.0.0.20"]
}