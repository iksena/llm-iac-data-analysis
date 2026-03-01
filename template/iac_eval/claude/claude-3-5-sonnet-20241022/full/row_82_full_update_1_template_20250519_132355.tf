I'll help you create a Terraform configuration for Active-Active Failover using AWS Route 53 with health checks for primary and secondary endpoints. This configuration will include:

1. A Route 53 hosted zone
2. Two health checks (primary and secondary)
3. Route 53 records with failover routing policy
4. Required variables and providers

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
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
</iac_template>

This configuration creates:
1. An AWS Route 53 hosted zone named "main"
2. Two health checks monitoring the primary and secondary endpoints
3. Two Route 53 records with failover routing policy (PRIMARY and SECONDARY)
4. All necessary variables with default values

The health checks will monitor the specified endpoints every 30 seconds, and if an endpoint fails 3 consecutive checks, Route 53 will consider it unhealthy and route traffic to the other endpoint. The configuration uses alias records to route traffic between the primary and secondary endpoints based on their health status.

To use this configuration, you would need to:
1. Replace the default domain names with your actual domain names
2. Ensure the endpoints are actually running and accessible
3. Make sure you have the necessary AWS credentials configured

The configuration follows AWS best practices for active-active failover and includes all necessary components for a working setup.