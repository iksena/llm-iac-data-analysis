resource "aws_route53_resolver_firewall_rule_group" "this" {
  region = var.region
  name   = var.name
  tags   = var.tags
}