output "firewall_rules" {
  description = "List with information about the firewall rules"
  value       = data.aws_route53_resolver_firewall_rules.this.firewall_rules
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_route53_resolver_firewall_rules.this.region
}

output "firewall_rule_group_id" {
  description = "The unique identifier of the firewall rule group"
  value       = data.aws_route53_resolver_firewall_rules.this.firewall_rule_group_id
}

output "action" {
  description = "The action that DNS Firewall should take on a DNS query"
  value       = data.aws_route53_resolver_firewall_rules.this.action
}

output "priority" {
  description = "The setting that determines the processing order of the rules"
  value       = data.aws_route53_resolver_firewall_rules.this.priority
}