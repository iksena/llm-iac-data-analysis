output "arn" {
  description = "Amazon Resource Name (ARN) of cluster instance"
  value       = aws_docdb_cluster_instance.this.arn
}

output "db_subnet_group_name" {
  description = "The DB subnet group to associate with this DB instance"
  value       = aws_docdb_cluster_instance.this.db_subnet_group_name
}

output "dbi_resource_id" {
  description = "The region-unique, immutable identifier for the DB instance"
  value       = aws_docdb_cluster_instance.this.dbi_resource_id
}

output "endpoint" {
  description = "The DNS address for this instance. May not be writable"
  value       = aws_docdb_cluster_instance.this.endpoint
}

output "engine_version" {
  description = "The database engine version"
  value       = aws_docdb_cluster_instance.this.engine_version
}

output "kms_key_id" {
  description = "The ARN for the KMS encryption key if one is set to the cluster"
  value       = aws_docdb_cluster_instance.this.kms_key_id
}

output "port" {
  description = "The database port"
  value       = aws_docdb_cluster_instance.this.port
}

output "preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled"
  value       = aws_docdb_cluster_instance.this.preferred_backup_window
}

output "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  value       = aws_docdb_cluster_instance.this.storage_encrypted
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_docdb_cluster_instance.this.tags_all
}

output "writer" {
  description = "Boolean indicating if this instance is writable. False indicates this instance is a read replica"
  value       = aws_docdb_cluster_instance.this.writer
}