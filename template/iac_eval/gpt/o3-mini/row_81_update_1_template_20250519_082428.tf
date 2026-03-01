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