output "arn" {
  description = "The ARN (Amazon Resource Name) of the domain list."
  value       = aws_route53_resolver_firewall_domain_list.this.arn
}

output "id" {
  description = "The ID of the domain list."
  value       = aws_route53_resolver_firewall_domain_list.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_route53_resolver_firewall_domain_list.this.tags_all
}