output "arn" {
  description = "ARN of the secret."
  value       = data.aws_secretsmanager_secret.this.arn
}

output "created_date" {
  description = "Created date of the secret in UTC."
  value       = data.aws_secretsmanager_secret.this.created_date
}

output "description" {
  description = "Description of the secret."
  value       = data.aws_secretsmanager_secret.this.description
}

output "kms_key_id" {
  description = "Key Management Service (KMS) Customer Master Key (CMK) associated with the secret."
  value       = data.aws_secretsmanager_secret.this.kms_key_id
}

output "id" {
  description = "ARN of the secret."
  value       = data.aws_secretsmanager_secret.this.id
}

output "last_changed_date" {
  description = "Last updated date of the secret in UTC."
  value       = data.aws_secretsmanager_secret.this.last_changed_date
}

output "policy" {
  description = "Resource-based policy document that's attached to the secret."
  value       = data.aws_secretsmanager_secret.this.policy
}

output "tags" {
  description = "Tags of the secret."
  value       = data.aws_secretsmanager_secret.this.tags
}