output "id" {
  description = "Same as name"
  value       = data.aws_memorydb_cluster.this.id
}

output "arn" {
  description = "ARN of the cluster"
  value       = data.aws_memorydb_cluster.this.arn
}

output "acl_name" {
  description = "Name of the Access Control List associated with the cluster"
  value       = data.aws_memorydb_cluster.this.acl_name
}

output "auto_minor_version_upgrade" {
  description = "True when the cluster allows automatic minor version upgrades"
  value       = data.aws_memorydb_cluster.this.auto_minor_version_upgrade
}

output "cluster_endpoint" {
  description = "Cluster endpoint configuration"
  value       = data.aws_memorydb_cluster.this.cluster_endpoint
}

output "data_tiering" {
  description = "True when data tiering is enabled"
  value       = data.aws_memorydb_cluster.this.data_tiering
}

output "description" {
  description = "Description for the cluster"
  value       = data.aws_memorydb_cluster.this.description
}

output "engine_patch_version" {
  description = "Patch version number of the engine used by the cluster"
  value       = data.aws_memorydb_cluster.this.engine_patch_version
}

output "engine" {
  description = "Engine that will run on cluster nodes"
  value       = data.aws_memorydb_cluster.this.engine
}

output "engine_version" {
  description = "Version number of the engine used by the cluster"
  value       = data.aws_memorydb_cluster.this.engine_version
}

output "final_snapshot_name" {
  description = "Name of the final cluster snapshot to be created when this resource is deleted"
  value       = data.aws_memorydb_cluster.this.final_snapshot_name
}

output "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the cluster at rest"
  value       = data.aws_memorydb_cluster.this.kms_key_arn
}

output "maintenance_window" {
  description = "Weekly time range during which maintenance on the cluster is performed"
  value       = data.aws_memorydb_cluster.this.maintenance_window
}

output "node_type" {
  description = "Compute and memory capacity of the nodes in the cluster"
  value       = data.aws_memorydb_cluster.this.node_type
}

output "num_replicas_per_shard" {
  description = "The number of replicas to apply to each shard"
  value       = data.aws_memorydb_cluster.this.num_replicas_per_shard
}

output "num_shards" {
  description = "Number of shards in the cluster"
  value       = data.aws_memorydb_cluster.this.num_shards
}

output "parameter_group_name" {
  description = "The name of the parameter group associated with the cluster"
  value       = data.aws_memorydb_cluster.this.parameter_group_name
}

output "port" {
  description = "Port number on which each of the nodes accepts connections"
  value       = data.aws_memorydb_cluster.this.port
}

output "security_group_ids" {
  description = "Set of VPC Security Group ID-s associated with this cluster"
  value       = data.aws_memorydb_cluster.this.security_group_ids
}

output "shards" {
  description = "Set of shards in this cluster"
  value       = data.aws_memorydb_cluster.this.shards
}

output "snapshot_retention_limit" {
  description = "The number of days for which MemoryDB retains automatic snapshots before deleting them"
  value       = data.aws_memorydb_cluster.this.snapshot_retention_limit
}

output "snapshot_window" {
  description = "Daily time range (in UTC) during which MemoryDB begins taking a daily snapshot of your shard"
  value       = data.aws_memorydb_cluster.this.snapshot_window
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic to which cluster notifications are sent"
  value       = data.aws_memorydb_cluster.this.sns_topic_arn
}

output "subnet_group_name" {
  description = "The name of the subnet group used for the cluster"
  value       = data.aws_memorydb_cluster.this.subnet_group_name
}

output "tls_enabled" {
  description = "When true, in-transit encryption is enabled for the cluster"
  value       = data.aws_memorydb_cluster.this.tls_enabled
}

output "tags" {
  description = "Map of tags assigned to the cluster"
  value       = data.aws_memorydb_cluster.this.tags
}