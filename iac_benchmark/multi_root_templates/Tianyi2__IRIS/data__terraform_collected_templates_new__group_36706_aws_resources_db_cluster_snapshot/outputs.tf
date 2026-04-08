output "allocated_storage" {
  description = "Allocated storage size in gigabytes (GB)."
  value       = aws_db_cluster_snapshot.this.allocated_storage
}

output "availability_zones" {
  description = "List of EC2 Availability Zones that instances in the DB cluster snapshot can be restored in."
  value       = aws_db_cluster_snapshot.this.availability_zones
}

output "db_cluster_snapshot_arn" {
  description = "The Amazon Resource Name (ARN) for the DB Cluster Snapshot."
  value       = aws_db_cluster_snapshot.this.db_cluster_snapshot_arn
}

output "engine" {
  description = "Name of the database engine."
  value       = aws_db_cluster_snapshot.this.engine
}

output "engine_version" {
  description = "Version of the database engine for this DB cluster snapshot."
  value       = aws_db_cluster_snapshot.this.engine_version
}

output "kms_key_id" {
  description = "If storage_encrypted is true, the AWS KMS key identifier for the encrypted DB cluster snapshot."
  value       = aws_db_cluster_snapshot.this.kms_key_id
}

output "license_model" {
  description = "License model information for the restored DB cluster."
  value       = aws_db_cluster_snapshot.this.license_model
}

output "port" {
  description = "Port that the DB cluster was listening on at the time of the snapshot."
  value       = aws_db_cluster_snapshot.this.port
}


output "storage_encrypted" {
  description = "Whether the DB cluster snapshot is encrypted."
  value       = aws_db_cluster_snapshot.this.storage_encrypted
}

output "status" {
  description = "The status of this DB Cluster Snapshot."
  value       = aws_db_cluster_snapshot.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_db_cluster_snapshot.this.tags_all
}

output "vpc_id" {
  description = "The VPC ID associated with the DB cluster snapshot."
  value       = aws_db_cluster_snapshot.this.vpc_id
}