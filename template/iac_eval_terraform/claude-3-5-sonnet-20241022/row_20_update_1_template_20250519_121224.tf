provider "aws" {
  region = "us-east-1"
}

# Variables
variable "domain_name" {
  description = "The domain name for the hosted zone"
  type        = string
  default     = "example.com"
}

variable "subdomain" {
  description = "The subdomain to create the A record for"
  type        = string
  default     = "www"
}

variable "target_ip" {
  description = "The IPv4 address to point the A record to"
  type        = string
  default     = "203.0.113.1"  # Example IP address
}

# Create Route 53 hosted zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# Create A record
resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.target_ip]
}

# Output the nameservers
output "nameservers" {
  description = "Nameservers for the hosted zone"
  value       = aws_route53_zone.main.name_servers
}