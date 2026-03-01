To configure an Active-Passive Failover policy using AWS Route 53, we will create a Route 53 health check and a failover routing policy. The health check will monitor the health of the primary resource, and the failover policy will direct traffic to a secondary resource if the primary resource becomes unhealthy. We will define a Route 53 hosted zone named "primary" and create two records: one for the primary resource with a health check and another for the secondary resource without a health check. The primary record will have a failover routing policy set to "PRIMARY," and the secondary record will have a failover routing policy set to "SECONDARY."

The following Terraform configuration will set up these resources:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "primary" {
  name = "primary.example.com"
}

resource "aws_route53_health_check" "primary_health_check" {
  fqdn              = "primary.example.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "primary"
  type    = "A"
  ttl     = 60

  records = ["192.0.2.1"]

  set_identifier = "Primary"
  failover_routing_policy {
    type = "PRIMARY"
  }

  health_check_id = aws_route53_health_check.primary_health_check.id
}

resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "primary"
  type    = "A"
  ttl     = 60

  records = ["192.0.2.2"]

  set_identifier = "Secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }
}
```
</iac_template>

This configuration sets up a Route 53 hosted zone named "primary.example.com" and creates two A records for failover. The primary record is associated with a health check, and the secondary record acts as a backup, taking over if the primary becomes unhealthy.