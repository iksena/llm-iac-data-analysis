output "id" {
  description = "Amazon Resource Name (ARN) of the secret"
  value       = aws_secretsmanager_secret_policy.this.id
}