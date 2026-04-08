output "id" {
  description = "The ARN of the rule (matches arn)"
  value       = aws_lb_listener_rule.this.id
}

output "arn" {
  description = "The ARN of the rule (matches id)"
  value       = aws_lb_listener_rule.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_lb_listener_rule.this.tags_all
}