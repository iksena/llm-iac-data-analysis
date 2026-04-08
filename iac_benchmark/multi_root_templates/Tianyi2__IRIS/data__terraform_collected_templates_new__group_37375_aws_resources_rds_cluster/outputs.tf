output "arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = aws_rds_cluster.this.arn
}

output "id" {
  description = "RDS Cluster Identifier"
  value       = aws_rds_cluster.this.id
}

output "cluster_identifier" {
  description = "RDS Cluster Identifier"
  value       = aws_rds_cluster.this.cluster_identifier
}

output "cluster_resource_id" {
  description = "RDS Cluster Resource ID"
  value       = aws_rds_cluster.this.cluster_resource_id
}

output "cluster_members" {
  description = "List of RDS Instances that are a part of this cluster"
  value       = aws_rds_cluster.this.cluster_members
}

output "availability_zones" {
  description = "Availability zone of the instance"
  value       = aws_rds_cluster.this.availability_zones
}

output "backup_retention_period" {
  description = "Backup retention period"
  value       = aws_rds_cluster.this.backup_retention_period
}

output "ca_certificate_identifier" {
  description = "CA identifier of the CA certificate used for the DB instance's server certificate"
  value       = aws_rds_cluster.this.ca_certificate_identifier
}

output "ca_certificate_valid_till" {
  description = "Expiration date of the DB instance's server certificate"
  value       = aws_rds_cluster.this.ca_certificate_valid_till
}

output "preferred_backup_window" {
  description = "Daily time range during which the backups happen"
  value       = aws_rds_cluster.this.preferred_backup_window
}

output "preferred_maintenance_window" {
  description = "Maintenance window"
  value       = aws_rds_cluster.this.preferred_maintenance_window
}

output "endpoint" {
  description = "DNS address of the RDS instance"
  value       = aws_rds_cluster.this.endpoint
}

output "reader_endpoint" {
  description = "Read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
  value       = aws_rds_cluster.this.reader_endpoint
}

output "engine" {
  description = "Database engine"
  value       = aws_rds_cluster.this.engine
}

output "engine_version_actual" {
  description = "Running version of the database"
  value       = aws_rds_cluster.this.engine_version_actual
}

output "database_name" {
  description = "Database name"
  value       = aws_rds_cluster.this.database_name
}

output "port" {
  description = "Database port"
  value       = aws_rds_cluster.this.port
}

output "master_username" {
  description = "Master username for the database"
  value       = aws_rds_cluster.this.master_username
}

output "master_user_secret" {
  description = "Block that specifies the master user secret. Only available when manage_master_user_password is set to true"
  value       = aws_rds_cluster.this.master_user_secret
  sensitive   = true
}

output "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  value       = aws_rds_cluster.this.storage_encrypted
}

output "replication_source_identifier" {
  description = "ARN of the source DB cluster or DB instance if this DB cluster is created as a Read Replica"
  value       = aws_rds_cluster.this.replication_source_identifier
}

output "hosted_zone_id" {
  description = "Route53 Hosted Zone ID of the endpoint"
  value       = aws_rds_cluster.this.hosted_zone_id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_rds_cluster.this.tags_all
}