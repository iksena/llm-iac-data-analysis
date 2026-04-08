output "id" {
  description = "The SES event destination name"
  value       = aws_ses_event_destination.this.id
}

output "arn" {
  description = "The SES event destination ARN"
  value       = aws_ses_event_destination.this.arn
}