resource "aws_route53_resolver_firewall_rule" "this" {
  name                               = var.name
  action                             = var.action
  block_override_dns_type            = var.block_override_dns_type
  block_override_domain              = var.block_override_domain
  block_override_ttl                 = var.block_override_ttl
  block_response                     = var.block_response
  firewall_domain_list_id            = var.firewall_domain_list_id
  firewall_domain_redirection_action = var.firewall_domain_redirection_action
  firewall_rule_group_id             = var.firewall_rule_group_id
  priority                           = var.priority
  q_type                             = var.q_type
}