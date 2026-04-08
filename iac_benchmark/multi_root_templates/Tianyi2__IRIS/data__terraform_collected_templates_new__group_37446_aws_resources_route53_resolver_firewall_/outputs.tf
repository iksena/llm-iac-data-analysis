output "arn" {
  description = "The ARN (Amazon Resource Name) of the firewall rule group association"
  value       = aws_route53_resolver_firewall_rule_group_association.this.arn
}

output "id" {
  description = "The identifier for the association"
  value       = aws_route53_resolver_firewall_rule_group_association.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_route53_resolver_firewall_rule_group_association.this.tags_all
}