output "id" {
  description = "The name of the rule."
  value       = aws_cloudwatch_event_rule.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the rule."
  value       = aws_cloudwatch_event_rule.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_cloudwatch_event_rule.this.tags_all
}