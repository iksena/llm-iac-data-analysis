provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "main" {
  name = "main.example.com"
}

resource "aws_route53_health_check" "primary_health_check" {
  fqdn              = "primary.example.com"
  type              = "HTTPS"
  port              = 443
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_health_check" "secondary_health_check" {
  fqdn              = "secondary.example.com"
  type              = "HTTPS"
  port              = 443
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "service.main.example.com"
  type    = "A"
  ttl     = 60

  set_identifier = "primary"
  failover_routing_policy {
    type = "PRIMARY"
  }

  health_check_id = aws_route53_health_check.primary_health_check.id
  records         = ["192.0.2.1"]
}

resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "service.main.example.com"
  type    = "A"
  ttl     = 60

  set_identifier = "secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }

  health_check_id = aws_route53_health_check.secondary_health_check.id
  records         = ["192.0.2.2"]
}