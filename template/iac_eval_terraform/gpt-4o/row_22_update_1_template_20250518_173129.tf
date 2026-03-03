provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "reverse_zone" {
  name = "reverse_zone"
}

resource "aws_route53_record" "ptr_record" {
  zone_id = aws_route53_zone.reverse_zone.zone_id
  name    = "1.0.0.127.in-addr.arpa" # Example IP address in reverse notation
  type    = "PTR"
  ttl     = 300
  records = ["host.example53.com"]
}