output "arn" {
  description = "The ARN of the SES template"
  value       = aws_ses_template.this.arn
}

output "id" {
  description = "The name of the SES template"
  value       = aws_ses_template.this.id
}