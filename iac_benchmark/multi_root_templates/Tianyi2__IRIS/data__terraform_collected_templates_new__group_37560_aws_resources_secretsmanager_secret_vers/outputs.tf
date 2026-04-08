output "arn" {
  description = "The ARN of the secret."
  value       = aws_secretsmanager_secret_version.this.arn
}

output "id" {
  description = "A pipe delimited combination of secret ID and version ID."
  value       = aws_secretsmanager_secret_version.this.id
}

output "version_id" {
  description = "The unique identifier of the version of the secret."
  value       = aws_secretsmanager_secret_version.this.version_id
}