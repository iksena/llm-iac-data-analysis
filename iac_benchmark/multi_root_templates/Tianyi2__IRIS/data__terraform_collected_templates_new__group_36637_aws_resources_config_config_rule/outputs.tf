output "arn" {
  description = "The ARN of the config rule"
  value       = aws_config_config_rule.this.arn
}

output "rule_id" {
  description = "The ID of the config rule"
  value       = aws_config_config_rule.this.rule_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_config_config_rule.this.tags_all
}