output "allocated_storage" {
  description = "Specifies the allocated storage size in gigabytes (GB)"
  value       = aws_rds_cluster_snapshot_copy.this.allocated_storage
}


output "db_cluster_snapshot_arn" {
  description = "The Amazon Resource Name (ARN) for the DB cluster snapshot"
  value       = aws_rds_cluster_snapshot_copy.this.db_cluster_snapshot_arn
}

output "engine" {
  description = "Specifies the name of the database engine"
  value       = aws_rds_cluster_snapshot_copy.this.engine
}

output "engine_version" {
  description = "Specifies the version of the database engine"
  value       = aws_rds_cluster_snapshot_copy.this.engine_version
}

output "id" {
  description = "Cluster snapshot identifier"
  value       = aws_rds_cluster_snapshot_copy.this.id
}

output "kms_key_id" {
  description = "ARN for the KMS encryption key"
  value       = aws_rds_cluster_snapshot_copy.this.kms_key_id
}

output "license_model" {
  description = "License model information for the restored DB instance"
  value       = aws_rds_cluster_snapshot_copy.this.license_model
}

output "shared_accounts" {
  description = "List of AWS Account IDs to share the snapshot with. Use 'all' to make the snapshot public"
  value       = aws_rds_cluster_snapshot_copy.this.shared_accounts
}

output "source_db_cluster_snapshot_identifier" {
  description = "DB snapshot ARN that the DB cluster snapshot was copied from. It only has value in case of cross customer or cross region copy"
  value       = aws_rds_cluster_snapshot_copy.this.source_db_cluster_snapshot_identifier
}

output "storage_encrypted" {
  description = "Specifies whether the DB cluster snapshot is encrypted"
  value       = aws_rds_cluster_snapshot_copy.this.storage_encrypted
}

output "storage_type" {
  description = "Specifies the storage type associated with DB cluster snapshot"
  value       = aws_rds_cluster_snapshot_copy.this.storage_type
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_rds_cluster_snapshot_copy.this.tags_all
}

output "vpc_id" {
  description = "Provides the VPC ID associated with the DB cluster snapshot"
  value       = aws_rds_cluster_snapshot_copy.this.vpc_id
}