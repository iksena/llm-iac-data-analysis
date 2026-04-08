resource "aws_route53_resolver_firewall_config" "this" {
  region             = var.region
  resource_id        = var.resource_id
  firewall_fail_open = var.firewall_fail_open
}