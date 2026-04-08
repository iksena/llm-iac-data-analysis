output "id" {
  description = "The ID of the rule"
  value       = aws_route53_resolver_firewall_rule.this.id
}

output "name" {
  description = "A name that lets you identify the rule, to manage and use it"
  value       = aws_route53_resolver_firewall_rule.this.name
}

output "action" {
  description = "The action that DNS Firewall should take on a DNS query when it matches one of the domains in the rule's domain list"
  value       = aws_route53_resolver_firewall_rule.this.action
}

output "block_override_dns_type" {
  description = "The DNS record's type. This determines the format of the record value that you provided in BlockOverrideDomain"
  value       = aws_route53_resolver_firewall_rule.this.block_override_dns_type
}

output "block_override_domain" {
  description = "The custom DNS record to send back in response to the query"
  value       = aws_route53_resolver_firewall_rule.this.block_override_domain
}

output "block_override_ttl" {
  description = "The recommended amount of time, in seconds, for the DNS resolver or web browser to cache the provided override record"
  value       = aws_route53_resolver_firewall_rule.this.block_override_ttl
}

output "block_response" {
  description = "The way that you want DNS Firewall to block the request"
  value       = aws_route53_resolver_firewall_rule.this.block_response
}

output "firewall_domain_list_id" {
  description = "The ID of the domain list that you want to use in the rule"
  value       = aws_route53_resolver_firewall_rule.this.firewall_domain_list_id
}

output "firewall_domain_redirection_action" {
  description = "Evaluate DNS redirection in the DNS redirection chain, such as CNAME, DNAME, ot ALIAS"
  value       = aws_route53_resolver_firewall_rule.this.firewall_domain_redirection_action
}

output "firewall_rule_group_id" {
  description = "The unique identifier of the firewall rule group where you want to create the rule"
  value       = aws_route53_resolver_firewall_rule.this.firewall_rule_group_id
}

output "priority" {
  description = "The setting that determines the processing order of the rule in the rule group"
  value       = aws_route53_resolver_firewall_rule.this.priority
}

output "q_type" {
  description = "The query type you want the rule to evaluate"
  value       = aws_route53_resolver_firewall_rule.this.q_type
}