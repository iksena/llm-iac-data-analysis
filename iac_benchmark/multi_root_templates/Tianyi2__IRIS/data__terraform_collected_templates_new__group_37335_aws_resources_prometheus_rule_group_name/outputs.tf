output "arn" {
  description = "The ARN of the rule group namespace."
  value       = aws_prometheus_rule_group_namespace.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_prometheus_rule_group_namespace.this.tags_all
}