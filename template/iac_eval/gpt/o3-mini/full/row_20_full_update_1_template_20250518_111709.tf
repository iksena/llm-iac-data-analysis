Below is the Terraform program description and complete HCL configuration that meets your business requirement. This program creates a new Route 53 hosted zone for the domain (with a default of "example.com") and then creates a DNS A record that maps a specified fully qualified domain name (with a default of "www.example.com") to an IPv4 address (with a default of "203.0.113.10").

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-west-2"
}

variable "zone_domain" {
  description = "The domain name of the hosted zone (e.g., example.com)."
  type        = string
  default     = "example.com"
}

variable "record_name" {
  description = "The fully qualified domain name for the A record (e.g., www.example.com)."
  type        = string
  default     = "www.example.com"
}

variable "ipv4_address" {
  description = "The IPv4 address to map to."
  type        = string
  default     = "203.0.113.10"
}

# Create a new Route 53 Hosted Zone for the domain
resource "aws_route53_zone" "primary_zone" {
  name = var.zone_domain
}

# Create an A record in the hosted zone to map the domain to the IPv4 address
resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.primary_zone.zone_id
  name    = var.record_name
  type    = "A"
  ttl     = 300
  records = [var.ipv4_address]
}
</iac_template>