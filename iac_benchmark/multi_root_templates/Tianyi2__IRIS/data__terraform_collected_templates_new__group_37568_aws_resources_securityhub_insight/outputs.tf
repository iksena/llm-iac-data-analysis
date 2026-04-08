output "id" {
  description = "ARN of the insight"
  value       = aws_securityhub_insight.this.id
}

output "arn" {
  description = "ARN of the insight"
  value       = aws_securityhub_insight.this.arn
}