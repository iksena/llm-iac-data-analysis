output "arn" {
  description = "The ARN for the listener rule."
  value       = aws_vpclattice_listener_rule.this.arn
}

output "rule_id" {
  description = "Unique identifier for the listener rule."
  value       = aws_vpclattice_listener_rule.this.rule_id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpclattice_listener_rule.this.tags_all
}