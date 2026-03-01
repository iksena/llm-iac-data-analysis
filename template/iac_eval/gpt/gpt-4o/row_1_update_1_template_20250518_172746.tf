provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_route53_zone" "example" {
  name = "example.com"
  vpc {
    vpc_id = aws_vpc.example.id
  }
}

resource "aws_route53_zone_association" "example" {
  zone_id = aws_route53_zone.example.zone_id
  vpc_id  = aws_vpc.example.id
}