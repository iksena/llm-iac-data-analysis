output "arn" {
  description = "Global Cluster Amazon Resource Name (ARN)"
  value       = aws_docdb_global_cluster.this.arn
}

output "global_cluster_members" {
  description = "Set of objects containing Global Cluster members"
  value       = aws_docdb_global_cluster.this.global_cluster_members
}

output "global_cluster_resource_id" {
  description = "AWS Region-unique, immutable identifier for the global database cluster. This identifier is found in AWS CloudTrail log entries whenever the AWS KMS key for the DB cluster is accessed"
  value       = aws_docdb_global_cluster.this.global_cluster_resource_id
}

output "id" {
  description = "DocumentDB Global Cluster ID"
  value       = aws_docdb_global_cluster.this.id
}

output "engine" {
  description = "The database engine"
  value       = aws_docdb_global_cluster.this.engine
}

output "engine_version" {
  description = "The engine version"
  value       = aws_docdb_global_cluster.this.engine_version
}

output "global_cluster_identifier" {
  description = "The global cluster identifier"
  value       = aws_docdb_global_cluster.this.global_cluster_identifier
}

output "database_name" {
  description = "The name of the automatically created database"
  value       = aws_docdb_global_cluster.this.database_name
}

output "deletion_protection" {
  description = "Whether deletion protection is enabled"
  value       = aws_docdb_global_cluster.this.deletion_protection
}

output "storage_encrypted" {
  description = "Whether the DB cluster is encrypted"
  value       = aws_docdb_global_cluster.this.storage_encrypted
}