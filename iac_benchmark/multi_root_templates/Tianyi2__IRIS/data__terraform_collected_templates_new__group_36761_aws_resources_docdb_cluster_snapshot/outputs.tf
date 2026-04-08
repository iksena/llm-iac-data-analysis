output "availability_zones" {
  description = "List of EC2 Availability Zones that instances in the DocumentDB cluster snapshot can be restored in."
  value       = aws_docdb_cluster_snapshot.this.availability_zones
}

output "db_cluster_snapshot_arn" {
  description = "The Amazon Resource Name (ARN) for the DocumentDB Cluster Snapshot."
  value       = aws_docdb_cluster_snapshot.this.db_cluster_snapshot_arn
}

output "engine" {
  description = "Specifies the name of the database engine."
  value       = aws_docdb_cluster_snapshot.this.engine
}

output "engine_version" {
  description = "Version of the database engine for this DocumentDB cluster snapshot."
  value       = aws_docdb_cluster_snapshot.this.engine_version
}

output "kms_key_id" {
  description = "If storage_encrypted is true, the AWS KMS key identifier for the encrypted DocumentDB cluster snapshot."
  value       = aws_docdb_cluster_snapshot.this.kms_key_id
}

output "port" {
  description = "Port that the DocumentDB cluster was listening on at the time of the snapshot."
  value       = aws_docdb_cluster_snapshot.this.port
}


output "storage_encrypted" {
  description = "Specifies whether the DocumentDB cluster snapshot is encrypted."
  value       = aws_docdb_cluster_snapshot.this.storage_encrypted
}

output "status" {
  description = "The status of this DocumentDB Cluster Snapshot."
  value       = aws_docdb_cluster_snapshot.this.status
}

output "vpc_id" {
  description = "The VPC ID associated with the DocumentDB cluster snapshot."
  value       = aws_docdb_cluster_snapshot.this.vpc_id
}