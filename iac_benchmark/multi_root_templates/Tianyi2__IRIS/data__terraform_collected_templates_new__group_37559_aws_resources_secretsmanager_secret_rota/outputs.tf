output "id" {
  description = "Amazon Resource Name (ARN) of the secret."
  value       = aws_secretsmanager_secret_rotation.this.id
}


output "rotation_enabled" {
  description = "Specifies whether automatic rotation is enabled for this secret."
  value       = aws_secretsmanager_secret_rotation.this.rotation_enabled
}