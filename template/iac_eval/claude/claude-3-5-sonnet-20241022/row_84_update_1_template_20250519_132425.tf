provider "aws" {
  region = "us-east-1"
}

# Create Route 53 zone
resource "aws_route53_zone" "primary" {
  name = "primary.example.com"
}

# Create health check for US endpoint
resource "aws_route53_health_check" "us_health" {
  fqdn              = "us-endpoint.primary.example.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "us-health-check"
  }
}

# Create health check for EU endpoint
resource "aws_route53_health_check" "eu_health" {
  fqdn              = "eu-endpoint.primary.example.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "eu-health-check"
  }
}

# Create weighted record for US endpoint
resource "aws_route53_record" "us_endpoint" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.primary.example.com"
  type    = "A"
  
  weighted_routing_policy {
    weight = 50
  }

  set_identifier = "us-east"
  health_check_id = aws_route53_health_check.us_health.id

  alias {
    name                   = "us-endpoint.primary.example.com"
    zone_id                = aws_route53_zone.primary.zone_id
    evaluate_target_health = true
  }
}

# Create weighted record for EU endpoint
resource "aws_route53_record" "eu_endpoint" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.primary.example.com"
  type    = "A"
  
  weighted_routing_policy {
    weight = 50
  }

  set_identifier = "eu-central"
  health_check_id = aws_route53_health_check.eu_health.id

  alias {
    name                   = "eu-endpoint.primary.example.com"
    zone_id                = aws_route53_zone.primary.zone_id
    evaluate_target_health = true
  }
}

# Create A record for US endpoint
resource "aws_route53_record" "us_endpoint_target" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "us-endpoint.primary.example.com"
  type    = "A"
  ttl     = "300"
  records = ["10.0.0.1"] # Replace with actual IP address
}

# Create A record for EU endpoint
resource "aws_route53_record" "eu_endpoint_target" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "eu-endpoint.primary.example.com"
  type    = "A"
  ttl     = "300"
  records = ["10.0.0.2"] # Replace with actual IP address
}