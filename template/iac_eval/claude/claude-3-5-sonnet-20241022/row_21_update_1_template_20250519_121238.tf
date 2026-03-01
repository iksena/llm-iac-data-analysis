provider "aws" {
  region = "us-east-1"  # Route 53 is a global service, but provider needs a region
}

# Variables
variable "domain_name" {
  description = "The domain name for the AAAA record"
  type        = string
  default     = "ipv6.example.com"
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone where the record will be created"
  type        = string
  default     = "Z0123456789ABCDEFGHIJ"  # Replace with your actual hosted zone ID
}

variable "ipv6_address" {
  description = "The IPv6 address to map to the domain"
  type        = string
  default     = "2001:0db8:85a3:0000:0000:8a2e:0370:7334"
}

# Create AAAA Record in Route 53
resource "aws_route53_record" "ipv6_record" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "AAAA"
  ttl     = 300
  records = [var.ipv6_address]
}