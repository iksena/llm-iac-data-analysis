data "aws_route53_resolver_firewall_rule_group" "this" {
  region                 = var.region
  firewall_rule_group_id = var.firewall_rule_group_id
}