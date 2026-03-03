terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

# Create a Route53 Hosted Zone named "main"
resource "aws_route53_zone" "main" {
  name = "main"
}

# Primary health check using a fully qualified domain name
resource "aws_route53_health_check" "primary_health_check" {
  fqdn                    = "primary.example.com"
  type                    = "HTTP"
  resource_path           = "/"
  failure_threshold       = 3
  request_interval        = 30
}

# Secondary health check using a fully qualified domain name
resource "aws_route53_health_check" "secondary_health_check" {
  fqdn                    = "secondary.example.com"
  type                    = "HTTP"
  resource_path           = "/"
  failure_threshold       = 3
  request_interval        = 30
}

# Primary DNS record with failover routing policy
resource "aws_route53_record" "primary_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "service"
  type    = "A"
  ttl     = 60
  records = ["192.0.2.1"]

  set_identifier = "primary"
  failover_routing_policy {
    type = "PRIMARY"
  }
  health_check_id = aws_route53_health_check.primary_health_check.id
}

# Secondary DNS record with failover routing policy
resource "aws_route53_record" "secondary_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "service"
  type    = "A"
  ttl     = 60
  records = ["192.0.2.2"]

  set_identifier = "secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }
  health_check_id = aws_route53_health_check.secondary_health_check.id
}