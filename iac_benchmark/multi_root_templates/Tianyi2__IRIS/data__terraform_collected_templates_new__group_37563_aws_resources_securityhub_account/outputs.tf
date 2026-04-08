output "id" {
  description = "AWS Account ID."
  value       = aws_securityhub_account.this.id
}

output "arn" {
  description = "ARN of the SecurityHub Hub created in the account."
  value       = aws_securityhub_account.this.arn
}