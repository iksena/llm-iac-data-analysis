provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "example" {
  name = "example.com"
}

resource "aws_route53_record" "txt_record" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "example.com"
  type    = "TXT"
  ttl     = 300
  records = ["\"passwordpassword\""]
}