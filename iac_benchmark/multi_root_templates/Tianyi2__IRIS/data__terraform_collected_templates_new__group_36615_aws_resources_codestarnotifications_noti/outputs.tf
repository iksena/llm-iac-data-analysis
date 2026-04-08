output "id" {
  description = "The codestar notification rule ARN"
  value       = aws_codestarnotifications_notification_rule.this.id
}

output "arn" {
  description = "The codestar notification rule ARN"
  value       = aws_codestarnotifications_notification_rule.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_codestarnotifications_notification_rule.this.tags_all
}