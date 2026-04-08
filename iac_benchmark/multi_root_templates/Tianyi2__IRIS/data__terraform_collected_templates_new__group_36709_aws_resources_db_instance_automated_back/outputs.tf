output "id" {
  description = "The Amazon Resource Name (ARN) of the replicated automated backups"
  value       = aws_db_instance_automated_backups_replication.this.id
}

output "source_db_instance_arn" {
  description = "The Amazon Resource Name (ARN) of the source DB instance for the replicated automated backups"
  value       = aws_db_instance_automated_backups_replication.this.source_db_instance_arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_db_instance_automated_backups_replication.this.region
}

output "kms_key_id" {
  description = "The AWS KMS key identifier for encryption of the replicated automated backups"
  value       = aws_db_instance_automated_backups_replication.this.kms_key_id
}

output "pre_signed_url" {
  description = "A URL that contains a Signature Version 4 signed request for the StartDBInstanceAutomatedBackupsReplication action"
  value       = aws_db_instance_automated_backups_replication.this.pre_signed_url
}

output "retention_period" {
  description = "The retention period for the replicated automated backups"
  value       = aws_db_instance_automated_backups_replication.this.retention_period
}