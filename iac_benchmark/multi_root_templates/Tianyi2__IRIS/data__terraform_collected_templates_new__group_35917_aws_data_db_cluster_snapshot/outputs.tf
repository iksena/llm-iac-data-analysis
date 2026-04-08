output "allocated_storage" {
  description = "Allocated storage size in gigabytes (GB)."
  value       = data.aws_db_cluster_snapshot.this.allocated_storage
}

output "availability_zones" {
  description = "List of EC2 Availability Zones that instances in the DB cluster snapshot can be restored in."
  value       = data.aws_db_cluster_snapshot.this.availability_zones
}

output "db_cluster_identifier" {
  description = "Specifies the DB cluster identifier of the DB cluster that this DB cluster snapshot was created from."
  value       = data.aws_db_cluster_snapshot.this.db_cluster_identifier
}

output "db_cluster_snapshot_arn" {
  description = "The ARN for the DB Cluster Snapshot."
  value       = data.aws_db_cluster_snapshot.this.db_cluster_snapshot_arn
}

output "engine_version" {
  description = "Version of the database engine for this DB cluster snapshot."
  value       = data.aws_db_cluster_snapshot.this.engine_version
}

output "engine" {
  description = "Name of the database engine."
  value       = data.aws_db_cluster_snapshot.this.engine
}

output "id" {
  description = "Snapshot ID."
  value       = data.aws_db_cluster_snapshot.this.id
}

output "kms_key_id" {
  description = "If storage_encrypted is true, the AWS KMS key identifier for the encrypted DB cluster snapshot."
  value       = data.aws_db_cluster_snapshot.this.kms_key_id
}

output "license_model" {
  description = "License model information for the restored DB cluster."
  value       = data.aws_db_cluster_snapshot.this.license_model
}

output "port" {
  description = "Port that the DB cluster was listening on at the time of the snapshot."
  value       = data.aws_db_cluster_snapshot.this.port
}

output "snapshot_create_time" {
  description = "Time when the snapshot was taken, in Universal Coordinated Time (UTC)."
  value       = data.aws_db_cluster_snapshot.this.snapshot_create_time
}


output "status" {
  description = "Status of this DB Cluster Snapshot."
  value       = data.aws_db_cluster_snapshot.this.status
}

output "storage_encrypted" {
  description = "Whether the DB cluster snapshot is encrypted."
  value       = data.aws_db_cluster_snapshot.this.storage_encrypted
}

output "vpc_id" {
  description = "VPC ID associated with the DB cluster snapshot."
  value       = data.aws_db_cluster_snapshot.this.vpc_id
}

output "tags" {
  description = "Map of tags for the resource."
  value       = data.aws_db_cluster_snapshot.this.tags
}