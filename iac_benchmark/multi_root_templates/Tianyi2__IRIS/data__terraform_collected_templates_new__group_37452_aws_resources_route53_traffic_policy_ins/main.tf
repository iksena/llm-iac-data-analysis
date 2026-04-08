resource "aws_route53_traffic_policy_instance" "this" {
  name                   = var.name
  traffic_policy_id      = var.traffic_policy_id
  traffic_policy_version = var.traffic_policy_version
  hosted_zone_id         = var.hosted_zone_id
  ttl                    = var.ttl
}