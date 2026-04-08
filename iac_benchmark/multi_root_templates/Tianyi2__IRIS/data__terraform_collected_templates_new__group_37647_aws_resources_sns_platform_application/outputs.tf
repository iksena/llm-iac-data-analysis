output "id" {
  description = "The ARN of the SNS platform application"
  value       = aws_sns_platform_application.this.id
}

output "arn" {
  description = "The ARN of the SNS platform application"
  value       = aws_sns_platform_application.this.arn
}