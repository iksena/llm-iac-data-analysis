output "arn" {
  description = "Amazon Resource Name (ARN) of cluster instance"
  value       = aws_rds_cluster_instance.this.arn
}

output "cluster_identifier" {
  description = "RDS Cluster Identifier"
  value       = aws_rds_cluster_instance.this.cluster_identifier
}

output "identifier" {
  description = "Instance identifier"
  value       = aws_rds_cluster_instance.this.identifier
}

output "id" {
  description = "Instance identifier"
  value       = aws_rds_cluster_instance.this.id
}

output "writer" {
  description = "Boolean indicating if this instance is writable. False indicates this instance is a read replica"
  value       = aws_rds_cluster_instance.this.writer
}

output "availability_zone" {
  description = "Availability zone of the instance"
  value       = aws_rds_cluster_instance.this.availability_zone
}

output "endpoint" {
  description = "DNS address for this instance. May not be writable"
  value       = aws_rds_cluster_instance.this.endpoint
}

output "engine" {
  description = "Database engine"
  value       = aws_rds_cluster_instance.this.engine
}

output "engine_version_actual" {
  description = "Database engine version"
  value       = aws_rds_cluster_instance.this.engine_version_actual
}

output "port" {
  description = "Database port"
  value       = aws_rds_cluster_instance.this.port
}

output "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  value       = aws_rds_cluster_instance.this.storage_encrypted
}

output "kms_key_id" {
  description = "ARN for the KMS encryption key if one is set to the cluster"
  value       = aws_rds_cluster_instance.this.kms_key_id
}

output "network_type" {
  description = "Network type of the DB instance"
  value       = aws_rds_cluster_instance.this.network_type
}

output "dbi_resource_id" {
  description = "Region-unique, immutable identifier for the DB instance"
  value       = aws_rds_cluster_instance.this.dbi_resource_id
}

output "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not"
  value       = aws_rds_cluster_instance.this.performance_insights_enabled
}

output "performance_insights_kms_key_id" {
  description = "ARN for the KMS encryption key used by Performance Insights"
  value       = aws_rds_cluster_instance.this.performance_insights_kms_key_id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_rds_cluster_instance.this.tags_all
}