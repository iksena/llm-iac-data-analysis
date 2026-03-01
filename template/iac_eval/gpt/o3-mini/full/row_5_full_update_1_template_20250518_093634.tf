Below is the design description followed by a complete Terraform HCL configuration.

Design Description:
• We create a Route 53 hosted zone named “main” (with FQDN “main.example.com”).
• We define a simple DNS A record for the primary DB instance (named “primary”) that points to its IP (default: 10.0.0.10). Its full domain becomes primary.main.example.com.
• We then create two Route 53 weighted record sets for the same DNS name (db.main.example.com). One record’s set_identifier is “replica-1” (pointing, by default, to 10.0.0.11) and the other “replica-2” (pointing to 10.0.0.12). Both weighted records are assigned equal weights so that user traffic is split evenly between the two DB replicas.
• A default provider configuration for AWS in the us-east-1 region is included along with all required variables.

Below is the deployable Terraform HCL configuration:

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

# DNS record for the primary (main) DB instance
resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "primary.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.primary_ip]
}

# Weighted DNS records for the replica DB instances.
# Both records share the same name ("db.main.example.com") to enable weighted routing.

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