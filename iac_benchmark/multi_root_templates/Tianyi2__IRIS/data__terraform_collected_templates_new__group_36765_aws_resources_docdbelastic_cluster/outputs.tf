output "arn" {
  description = "ARN of the DocumentDB Elastic Cluster"
  value       = aws_docdbelastic_cluster.this.arn
}

output "endpoint" {
  description = "The DNS address of the DocDB instance"
  value       = aws_docdbelastic_cluster.this.endpoint
}

output "admin_user_name" {
  description = "Name of the Elastic DocumentDB cluster administrator"
  value       = aws_docdbelastic_cluster.this.admin_user_name
}

output "auth_type" {
  description = "Authentication type for the Elastic DocumentDB cluster"
  value       = aws_docdbelastic_cluster.this.auth_type
}

output "name" {
  description = "Name of the Elastic DocumentDB cluster"
  value       = aws_docdbelastic_cluster.this.name
}

output "shard_capacity" {
  description = "Number of vCPUs assigned to each elastic cluster shard"
  value       = aws_docdbelastic_cluster.this.shard_capacity
}

output "shard_count" {
  description = "Number of shards assigned to the elastic cluster"
  value       = aws_docdbelastic_cluster.this.shard_count
}

output "backup_retention_period" {
  description = "The number of days for which automatic snapshots are retained"
  value       = aws_docdbelastic_cluster.this.backup_retention_period
}

output "kms_key_id" {
  description = "ARN of a KMS key that is used to encrypt the Elastic DocumentDB cluster"
  value       = aws_docdbelastic_cluster.this.kms_key_id
}

output "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  value       = aws_docdbelastic_cluster.this.preferred_backup_window
}

output "preferred_maintenance_window" {
  description = "Weekly time range during which system maintenance can occur in UTC"
  value       = aws_docdbelastic_cluster.this.preferred_maintenance_window
}

output "subnet_ids" {
  description = "IDs of subnets in which the Elastic DocumentDB Cluster operates"
  value       = aws_docdbelastic_cluster.this.subnet_ids
}

output "tags" {
  description = "A map of tags assigned to the collection"
  value       = aws_docdbelastic_cluster.this.tags
}

output "vpc_security_group_ids" {
  description = "List of VPC security groups associated with the Elastic DocumentDB Cluster"
  value       = aws_docdbelastic_cluster.this.vpc_security_group_ids
}