Below is a description of the Terraform program followed by the complete HCL configuration.

Description:
• The provider is configured with AWS in region "us-east-1".
• An Amazon Route 53 hosted zone is created with the domain name "primary.example.com" but is referred to as "primary" per the business need.
• A Route 53 health check resource is configured and named "primary_health_check". This health check uses a fully-qualified domain name (in this case "www.primary.example.com") as the endpoint to monitor.
• Two Route 53 DNS record sets are created to implement an active-passive failover configuration. The first record (type A and set as PRIMARY) is associated with the "primary_health_check" and returns IP "192.0.2.1". The second record (type A and marked as SECONDARY) returns IP "192.0.2.2" and will serve traffic if the health check for the primary record fails.
• No extra IAM roles are strictly needed since the provider’s IAM credentials are assumed to have the required permissions.

Below is the complete, deployable Terraform configuration.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Create a hosted zone named "primary.example.com" (called "primary")
resource "aws_route53_zone" "primary_zone" {
  name = "primary.example.com"
}

# Create a health check resource with FQDN "www.primary.example.com"
resource "aws_route53_health_check" "primary_health_check" {
  fqdn              = "www.primary.example.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
}

# Create a DNS record for the primary (active) endpoint with failover routing policy
resource "aws_route53_record" "primary_record" {
  zone_id = aws_route53_zone.primary_zone.zone_id
  name    = "app.primary.example.com"
  type    = "A"
  ttl     = 60
  
  records = ["192.0.2.1"]

  set_identifier = "primary"

  failover_routing_policy {
    type = "PRIMARY"
  }
  
  health_check_id = aws_route53_health_check.primary_health_check.id
}

# Create a DNS record for the secondary (passive) endpoint with failover routing policy.
resource "aws_route53_record" "secondary_record" {
  zone_id = aws_route53_zone.primary_zone.zone_id
  name    = "app.primary.example.com"
  type    = "A"
  ttl     = 60
  
  records = ["192.0.2.2"]

  set_identifier = "secondary"

  failover_routing_policy {
    type = "SECONDARY"
  }
}
</iac_template>