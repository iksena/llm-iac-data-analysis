provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_route53_zone" "private_zone" {
  name = "internal.example53.com"
  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "example_record" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "app.internal.example53.com"
  type    = "A"
  ttl     = "300"
  records = ["10.0.0.10"]
}