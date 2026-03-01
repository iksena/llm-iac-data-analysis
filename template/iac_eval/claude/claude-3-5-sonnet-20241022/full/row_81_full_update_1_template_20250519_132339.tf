I'll help you create a Terraform configuration for implementing Active-Passive Failover using AWS Route 53. This configuration will:

1. Create a Route 53 health check to monitor the primary endpoint
2. Set up a Route 53 hosted zone
3. Create DNS records with failover routing policy
4. Configure primary and secondary record sets

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This configuration creates:

1. An AWS Route 53 health check named "primary_health_check" that monitors the primary endpoint using HTTP
2. A Route 53 hosted zone named "primary"
3. Two Route 53 record sets:
   - A primary record with failover routing policy
   - A secondary record that serves as the backup

The health check will monitor the primary endpoint, and if it fails, Route 53 will automatically route traffic to the secondary endpoint. The configuration uses variables with default values for flexibility, and all necessary resources are properly declared and referenced.

To use this configuration, you would need to:
1. Replace the default domain names with your actual domain names
2. Ensure your AWS credentials are properly configured
3. Make sure the endpoints you're routing to actually exist and are accessible

The configuration uses the us-east-1 region, but you can modify this as needed for your use case.