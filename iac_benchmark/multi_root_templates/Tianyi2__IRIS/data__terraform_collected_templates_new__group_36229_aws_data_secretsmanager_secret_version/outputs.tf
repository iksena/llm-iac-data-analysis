output "arn" {
  description = "ARN of the secret."
  value       = data.aws_secretsmanager_secret_version.this.arn
}

output "created_date" {
  description = "Created date of the secret in UTC."
  value       = data.aws_secretsmanager_secret_version.this.created_date
}

output "id" {
  description = "Unique identifier of this version of the secret."
  value       = data.aws_secretsmanager_secret_version.this.id
}

output "secret_string" {
  description = "Decrypted part of the protected secret information that was originally provided as a string."
  value       = data.aws_secretsmanager_secret_version.this.secret_string
  sensitive   = true
}

output "secret_binary" {
  description = "Decrypted part of the protected secret information that was originally provided as a binary."
  value       = data.aws_secretsmanager_secret_version.this.secret_binary
  sensitive   = true
}

output "version_id" {
  description = "Unique identifier of this version of the secret."
  value       = data.aws_secretsmanager_secret_version.this.version_id
}