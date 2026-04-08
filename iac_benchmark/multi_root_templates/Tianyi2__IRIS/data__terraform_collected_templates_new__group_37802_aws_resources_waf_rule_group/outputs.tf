output "id" {
  description = "The ID of the WAF rule group"
  value       = aws_waf_rule_group.this.id
}

output "arn" {
  description = "The ARN of the WAF rule group"
  value       = aws_waf_rule_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_waf_rule_group.this.tags_all
}