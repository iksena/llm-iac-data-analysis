output "id" {
  description = "The Amazon Resource Name (ARN) that identifies the rule group"
  value       = aws_networkfirewall_rule_group.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) that identifies the rule group"
  value       = aws_networkfirewall_rule_group.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkfirewall_rule_group.this.tags_all
}

output "update_token" {
  description = "A string token used when updating the rule group"
  value       = aws_networkfirewall_rule_group.this.update_token
}