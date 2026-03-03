provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "primary" {
  name = "primary.example.com"
}

resource "aws_route53_record" "us_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "us.primary.example.com"
  type    = "A"
  ttl     = 300
  records = ["192.0.2.1"] # Replace with the actual US endpoint IP or domain

  geolocation_routing_policy {
    continent = "NA"
  }
}

resource "aws_route53_record" "eu_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "eu.primary.example.com"
  type    = "A"
  ttl     = 300
  records = ["192.0.2.2"] # Replace with the actual EU endpoint IP or domain

  geolocation_routing_policy {
    continent = "EU"
  }
}