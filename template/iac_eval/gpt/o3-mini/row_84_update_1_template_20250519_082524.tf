provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region for the provider"
  default     = "us-east-1"
}

variable "domain_name" {
  description = "The primary domain name for the hosted zone"
  default     = "primary.example.com"
}

variable "record_name" {
  description = "Subdomain name for the application routing"
  default     = "app"
}

# Create a public Route 53 hosted zone named "primary.example.com"
resource "aws_route53_zone" "primary" {
  name = var.domain_name
  comment = "Hosted zone named primary for routing via weighted policy"
}

# A Record for the US East (us-east-1) endpoint using weighted routing
resource "aws_route53_record" "us_east_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.record_name}.${var.domain_name}"
  type    = "A"
  ttl     = 60

  weighted_routing_policy {
    weight         = 1
    set_identifier = "us-east-1"
  }

  # Dummy IP for the US East endpoint.
  records = ["192.0.2.1"]
}

# A Record for the EU Central (eu-central-1) endpoint using weighted routing
resource "aws_route53_record" "eu_central_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.record_name}.${var.domain_name}"
  type    = "A"
  ttl     = 60

  weighted_routing_policy {
    weight         = 1
    set_identifier = "eu-central-1"
  }

  # Dummy IP for the EU Central endpoint.
  records = ["192.0.2.2"]
}