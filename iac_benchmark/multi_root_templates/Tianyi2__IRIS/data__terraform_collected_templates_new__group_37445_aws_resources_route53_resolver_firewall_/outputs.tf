output "arn" {
  description = "The ARN (Amazon Resource Name) of the rule group"
  value       = aws_route53_resolver_firewall_rule_group.this.arn
}

output "id" {
  description = "The ID of the rule group"
  value       = aws_route53_resolver_firewall_rule_group.this.id
}

output "owner_id" {
  description = "The AWS account ID for the account that created the rule group"
  value       = aws_route53_resolver_firewall_rule_group.this.owner_id
}

output "share_status" {
  description = "Whether the rule group is shared with other AWS accounts"
  value       = aws_route53_resolver_firewall_rule_group.this.share_status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_route53_resolver_firewall_rule_group.this.tags_all
}