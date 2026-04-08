output "arn" {
  description = "ARN of the Event Rule."
  value       = aws_notifications_event_rule.this.arn
}