output "id" {
  description = "The ID of the WAF Regional Rule Group"
  value       = aws_wafregional_rule_group.this.id
}

output "arn" {
  description = "The ARN of the WAF Regional Rule Group"
  value       = aws_wafregional_rule_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_wafregional_rule_group.this.tags_all
}