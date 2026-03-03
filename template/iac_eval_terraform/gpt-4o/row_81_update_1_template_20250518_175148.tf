provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "primary" {
  name = "primary.example.com"
}

resource "aws_route53_health_check" "primary_health_check" {
  fqdn              = "primary.example.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "primary"
  type    = "A"
  ttl     = 60

  records = ["192.0.2.1"]

  set_identifier = "Primary"
  failover_routing_policy {
    type = "PRIMARY"
  }

  health_check_id = aws_route53_health_check.primary_health_check.id
}

resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "primary"
  type    = "A"
  ttl     = 60

  records = ["192.0.2.2"]

  set_identifier = "Secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }
}