output "id" {
  description = "ARN of the secret."
  value       = aws_secretsmanager_secret.this.id
}

output "arn" {
  description = "ARN of the secret."
  value       = aws_secretsmanager_secret.this.arn
}

output "replica" {
  description = "Attributes of a replica."
  value = [
    for replica in aws_secretsmanager_secret.this.replica : {
      kms_key_id         = replica.kms_key_id
      region             = replica.region
      last_accessed_date = replica.last_accessed_date
      status             = replica.status
      status_message     = replica.status_message
    }
  ]
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_secretsmanager_secret.this.tags_all
}