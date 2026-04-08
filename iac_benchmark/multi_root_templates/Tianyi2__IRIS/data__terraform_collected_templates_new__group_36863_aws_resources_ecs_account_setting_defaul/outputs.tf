output "principal_arn" {
  description = "ARN that identifies the account setting."
  value       = aws_ecs_account_setting_default.this.principal_arn
}