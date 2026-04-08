resource "aws_route53_resolver_firewall_rule_group_association" "this" {
  region                 = var.region
  name                   = var.name
  firewall_rule_group_id = var.firewall_rule_group_id
  mutation_protection    = var.mutation_protection
  priority               = var.priority
  vpc_id                 = var.vpc_id
  tags                   = var.tags
}