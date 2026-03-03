<iac_template>
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "domain_name" {
  description = "The domain name for the hosted zone."
  type        = string
  default     = "main.example.com"
}

variable "primary_ip" {
  description = "IP address for the primary DB instance."
  type        = string
  default     = "10.0.0.10"
}

variable "replica1_ip" {
  description = "IP address for replica-1 DB instance."
  type        = string
  default     = "10.0.0.11"
}

variable "replica2_ip" {
  description = "IP address for replica-2 DB instance."
  type        = string
  default     = "10.0.0.12"
}

# Create the Route 53 hosted zone named "main"
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# DNS record for the primary DB instance (non-weighted)
resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "primary.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.primary_ip]
}

# Weighted DNS record for replica-1
resource "aws_route53_record" "replica_1" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "db.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.replica1_ip]

  set_identifier = "replica-1"

  weighted_routing_policy {
    weight = 50
  }
}

# Weighted DNS record for replica-2
resource "aws_route53_record" "replica_2" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "db.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.replica2_ip]

  set_identifier = "replica-2"

  weighted_routing_policy {
    weight = 50
  }
}
</iac_template>