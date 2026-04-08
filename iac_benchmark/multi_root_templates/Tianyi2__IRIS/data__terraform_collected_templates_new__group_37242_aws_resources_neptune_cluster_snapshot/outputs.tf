output "allocated_storage" {
  description = "Specifies the allocated storage size in gigabytes (GB)."
  value       = aws_neptune_cluster_snapshot.this.allocated_storage
}

output "availability_zones" {
  description = "List of EC2 Availability Zones that instances in the DB cluster snapshot can be restored in."
  value       = aws_neptune_cluster_snapshot.this.availability_zones
}

output "db_cluster_snapshot_arn" {
  description = "The Amazon Resource Name (ARN) for the DB Cluster Snapshot."
  value       = aws_neptune_cluster_snapshot.this.db_cluster_snapshot_arn
}

output "engine" {
  description = "Specifies the name of the database engine."
  value       = aws_neptune_cluster_snapshot.this.engine
}

output "engine_version" {
  description = "Version of the database engine for this DB cluster snapshot."
  value       = aws_neptune_cluster_snapshot.this.engine_version
}

output "kms_key_id" {
  description = "If storage_encrypted is true, the AWS KMS key identifier for the encrypted DB cluster snapshot."
  value       = aws_neptune_cluster_snapshot.this.kms_key_id
}

output "license_model" {
  description = "License model information for the restored DB cluster."
  value       = aws_neptune_cluster_snapshot.this.license_model
}

output "port" {
  description = "Port that the DB cluster was listening on at the time of the snapshot."
  value       = aws_neptune_cluster_snapshot.this.port
}

output "source_db_cluster_snapshot_arn" {
  description = "The DB Cluster Snapshot Arn that the DB Cluster Snapshot was copied from. It only has value in case of cross customer or cross region copy."
  value       = aws_neptune_cluster_snapshot.this.source_db_cluster_snapshot_arn
}

output "storage_encrypted" {
  description = "Specifies whether the DB cluster snapshot is encrypted."
  value       = aws_neptune_cluster_snapshot.this.storage_encrypted
}

output "status" {
  description = "The status of this DB Cluster Snapshot."
  value       = aws_neptune_cluster_snapshot.this.status
}

output "vpc_id" {
  description = "The VPC ID associated with the DB cluster snapshot."
  value       = aws_neptune_cluster_snapshot.this.vpc_id
}