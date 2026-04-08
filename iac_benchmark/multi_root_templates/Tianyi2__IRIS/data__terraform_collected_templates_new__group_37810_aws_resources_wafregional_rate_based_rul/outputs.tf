output "id" {
  description = "The ID of the WAF Regional Rate Based Rule."
  value       = aws_wafregional_rate_based_rule.this.id
}

output "arn" {
  description = "The ARN of the WAF Regional Rate Based Rule."
  value       = aws_wafregional_rate_based_rule.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_wafregional_rate_based_rule.this.tags_all
}