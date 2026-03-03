To configure Active-Active Failover policies using AWS Route 53, we will create a Route 53 hosted zone named "main". Within this zone, we will define two health checks: "primary_health_check" and "secondary_health_check". These health checks will monitor the health of two endpoints using their fully qualified domain names (FQDNs). We will then create two Route 53 records with failover routing policies, associating each with one of the health checks. This setup ensures that traffic is distributed between the two endpoints, and if one becomes unhealthy, Route 53 will automatically failover to the other.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "main" {
  name = "main.example.com"
}

resource "aws_route53_health_check" "primary_health_check" {
  fqdn              = "primary.example.com"
  type              = "HTTPS"
  port              = 443
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_health_check" "secondary_health_check" {
  fqdn              = "secondary.example.com"
  type              = "HTTPS"
  port              = 443
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "service.main.example.com"
  type    = "A"
  ttl     = 60

  set_identifier = "primary"
  failover_routing_policy {
    type = "PRIMARY"
  }

  health_check_id = aws_route53_health_check.primary_health_check.id
  records         = ["192.0.2.1"]
}

resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "service.main.example.com"
  type    = "A"
  ttl     = 60

  set_identifier = "secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }

  health_check_id = aws_route53_health_check.secondary_health_check.id
  records         = ["192.0.2.2"]
}
```
</iac_template>

This configuration sets up an Active-Active failover using Route 53, where both the primary and secondary endpoints are monitored, and traffic is routed based on their health status.