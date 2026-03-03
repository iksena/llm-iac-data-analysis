provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "example" {
  name = "example53.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "www.example53.com"
  type    = "A"
  ttl     = 300
  records = ["192.0.2.44"]  # Example IP address
}