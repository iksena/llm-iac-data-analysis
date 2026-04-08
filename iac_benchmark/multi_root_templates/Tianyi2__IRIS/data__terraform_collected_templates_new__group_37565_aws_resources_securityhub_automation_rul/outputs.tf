output "id" {
  description = "The ID of the Security Hub automation rule (matches arn)"
  value       = aws_securityhub_automation_rule.this.id
}

output "arn" {
  description = "The ARN of the Security Hub automation rule"
  value       = aws_securityhub_automation_rule.this.arn
}