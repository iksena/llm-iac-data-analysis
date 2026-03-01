provider "aws" {
  region = "us-east-1"
}

# Variables
variable "domain_name" {
  description = "Domain name for the Route 53 zone"
  type        = string
  default     = "example.com"
}

variable "primary_endpoint" {
  description = "Primary endpoint FQDN"
  type        = string
  default     = "primary.example.com"
}

variable "secondary_endpoint" {
  description = "Secondary endpoint FQDN"
  type        = string
  default     = "secondary.example.com"
}

# Create Route 53 health check for primary endpoint
resource "aws_route53_health_check" "primary_health_check" {
  fqdn              = var.primary_endpoint
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "primary-health-check"
  }
}

# Create Route 53 zone
resource "aws_route53_zone" "primary" {
  name = var.domain_name

  tags = {
    Environment = "production"
  }
}

# Create primary record
resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier = "primary"
  health_check_id = aws_route53_health_check.primary_health_check.id

  alias {
    name                   = var.primary_endpoint
    zone_id               = aws_route53_zone.primary.zone_id
    evaluate_target_health = true
  }
}

# Create secondary record
resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "A"

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "secondary"

  alias {
    name                   = var.secondary_endpoint
    zone_id               = aws_route53_zone.primary.zone_id
    evaluate_target_health = true
  }
}