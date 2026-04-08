output "id" {
  description = "Snapshot Identifier."
  value       = aws_db_snapshot_copy.this.id
}

output "allocated_storage" {
  description = "Specifies the allocated storage size in gigabytes (GB)."
  value       = aws_db_snapshot_copy.this.allocated_storage
}

output "availability_zone" {
  description = "Specifies the name of the Availability Zone the DB instance was located in at the time of the DB snapshot."
  value       = aws_db_snapshot_copy.this.availability_zone
}

output "db_snapshot_arn" {
  description = "The Amazon Resource Name (ARN) for the DB snapshot."
  value       = aws_db_snapshot_copy.this.db_snapshot_arn
}

output "encrypted" {
  description = "Specifies whether the DB snapshot is encrypted."
  value       = aws_db_snapshot_copy.this.encrypted
}

output "engine" {
  description = "Specifies the name of the database engine."
  value       = aws_db_snapshot_copy.this.engine
}

output "engine_version" {
  description = "Specifies the version of the database engine."
  value       = aws_db_snapshot_copy.this.engine_version
}

output "iops" {
  description = "Specifies the Provisioned IOPS (I/O operations per second) value of the DB instance at the time of the snapshot."
  value       = aws_db_snapshot_copy.this.iops
}

output "kms_key_id" {
  description = "The ARN for the KMS encryption key."
  value       = aws_db_snapshot_copy.this.kms_key_id
}

output "license_model" {
  description = "License model information for the restored DB instance."
  value       = aws_db_snapshot_copy.this.license_model
}

output "option_group_name" {
  description = "Provides the option group name for the DB snapshot."
  value       = aws_db_snapshot_copy.this.option_group_name
}

output "shared_accounts" {
  description = "List of AWS Account IDs to share the snapshot with. Use 'all' to make the snapshot public."
  value       = aws_db_snapshot_copy.this.shared_accounts
}

output "source_db_snapshot_identifier" {
  description = "The DB snapshot Arn that the DB snapshot was copied from. It only has value in case of cross customer or cross region copy."
  value       = aws_db_snapshot_copy.this.source_db_snapshot_identifier
}

output "source_region" {
  description = "The region that the DB snapshot was created in or copied from."
  value       = aws_db_snapshot_copy.this.source_region
}

output "storage_type" {
  description = "Specifies the storage type associated with DB snapshot."
  value       = aws_db_snapshot_copy.this.storage_type
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_db_snapshot_copy.this.tags_all
}

output "vpc_id" {
  description = "Provides the VPC ID associated with the DB snapshot."
  value       = aws_db_snapshot_copy.this.vpc_id
}