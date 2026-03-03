terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "The domain name for the hosted zone."
  type        = string
  default     = "example.com"
}

variable "record_name" {
  description = "The subdomain name for the AAAA record. The full record will be record_name.domain_name (e.g. ipv6.example.com)."
  type        = string
  default     = "ipv6"
}

variable "ipv6_address" {
  description = "The IPv6 address to be mapped to the subdomain."
  type        = string
  default     = "2001:db8::1"
}

# Create a public hosted zone for the provided domain
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

# Create a AAAA record for the subdomain mapping to the provided IPv6 address
resource "aws_route53_record" "ipv6_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.record_name}.${var.domain_name}"
  type    = "AAAA"
  ttl     = 300
  records = [var.ipv6_address]
}