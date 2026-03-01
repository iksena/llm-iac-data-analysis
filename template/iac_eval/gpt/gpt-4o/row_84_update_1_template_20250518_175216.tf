provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "primary" {
  name = "primary"
}

resource "aws_route53_record" "us_east_1" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "us-east-1.primary"
  type    = "A"
  set_identifier = "us-east-1"
  latency_routing_policy {
    region = "us-east-1"
  }
  ttl     = 60
  records = ["192.0.2.1"] # Replace with the actual IP address of the endpoint in us-east-1
}

resource "aws_route53_record" "eu_central_1" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "eu-central-1.primary"
  type    = "A"
  set_identifier = "eu-central-1"
  latency_routing_policy {
    region = "eu-central-1"
  }
  ttl     = 60
  records = ["192.0.2.2"] # Replace with the actual IP address of the endpoint in eu-central-1
}