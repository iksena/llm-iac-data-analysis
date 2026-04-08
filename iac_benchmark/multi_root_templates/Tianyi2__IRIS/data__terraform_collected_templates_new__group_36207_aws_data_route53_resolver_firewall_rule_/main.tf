data "aws_route53_resolver_firewall_rule_group_association" "this" {
  region                             = var.region
  firewall_rule_group_association_id = var.firewall_rule_group_association_id
}