output "id" {
  description = "ID of the resolver rule."
  value       = aws_route53_resolver_rule.this.id
}

output "arn" {
  description = "ARN (Amazon Resource Name) for the resolver rule."
  value       = aws_route53_resolver_rule.this.arn
}

output "owner_id" {
  description = "When a rule is shared with another AWS account, the account ID of the account that the rule is shared with."
  value       = aws_route53_resolver_rule.this.owner_id
}

output "share_status" {
  description = "Whether the rules is shared and, if so, whether the current account is sharing the rule with another account, or another account is sharing the rule with the current account. Values are NOT_SHARED, SHARED_BY_ME or SHARED_WITH_ME."
  value       = aws_route53_resolver_rule.this.share_status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_route53_resolver_rule.this.tags_all
}