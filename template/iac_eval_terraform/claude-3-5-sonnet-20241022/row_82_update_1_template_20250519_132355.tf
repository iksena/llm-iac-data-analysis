provider "aws" {
  region = "us-east-1"
}

# Variables
variable "domain_name" {
  description = "The domain name for the Route 53 zone"
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

# Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# Health Check for Primary Endpoint
resource "aws_route53_health_check" "primary_health_check" {
  fqdn              = var.primary_endpoint
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "Primary Health Check"
  }
}

# Health Check for Secondary Endpoint
resource "aws_route53_health_check" "secondary_health_check" {
  fqdn              = var.secondary_endpoint
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "Secondary Health Check"
  }
}

# Primary Record
resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"
  
  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier = "primary"
  
  alias {
    name                   = var.primary_endpoint
    zone_id                = aws_route53_zone.main.zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.primary_health_check.id
}

# Secondary Record
resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"
  
  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "secondary"
  
  alias {
    name                   = var.secondary_endpoint
    zone_id                = aws_route53_zone.main.zone_id
    evaluate_target_health = true
  }

  health_check_id = aws_route53_health_check.secondary_health_check.id
}