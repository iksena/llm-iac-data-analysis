output "id" {
  description = "The name of the snapshot."
  value       = aws_memorydb_snapshot.this.id
}

output "arn" {
  description = "The ARN of the snapshot."
  value       = aws_memorydb_snapshot.this.arn
}

output "cluster_configuration" {
  description = "The configuration of the cluster from which the snapshot was taken."
  value       = aws_memorydb_snapshot.this.cluster_configuration
}

output "cluster_configuration_description" {
  description = "Description for the cluster."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].description, null)
}

output "cluster_configuration_engine" {
  description = "The engine that will run on cluster nodes."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].engine, null)
}

output "cluster_configuration_engine_version" {
  description = "Version number of the engine used by the cluster."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].engine_version, null)
}

output "cluster_configuration_maintenance_window" {
  description = "The weekly time range during which maintenance on the cluster is performed."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].maintenance_window, null)
}

output "cluster_configuration_name" {
  description = "Name of the cluster."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].name, null)
}

output "cluster_configuration_node_type" {
  description = "Compute and memory capacity of the nodes in the cluster."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].node_type, null)
}

output "cluster_configuration_num_shards" {
  description = "Number of shards in the cluster."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].num_shards, null)
}

output "cluster_configuration_parameter_group_name" {
  description = "Name of the parameter group associated with the cluster."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].parameter_group_name, null)
}

output "cluster_configuration_port" {
  description = "Port number on which the cluster accepts connections."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].port, null)
}

output "cluster_configuration_snapshot_retention_limit" {
  description = "Number of days for which MemoryDB retains automatic snapshots before deleting them."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].snapshot_retention_limit, null)
}

output "cluster_configuration_snapshot_window" {
  description = "The daily time range (in UTC) during which MemoryDB begins taking a daily snapshot of the shard."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].snapshot_window, null)
}

output "cluster_configuration_subnet_group_name" {
  description = "Name of the subnet group used by the cluster."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].subnet_group_name, null)
}

output "cluster_configuration_topic_arn" {
  description = "ARN of the SNS topic to which cluster notifications are sent."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].topic_arn, null)
}

output "cluster_configuration_vpc_id" {
  description = "The VPC in which the cluster exists."
  value       = try(aws_memorydb_snapshot.this.cluster_configuration[0].vpc_id, null)
}

output "source" {
  description = "Indicates whether the snapshot is from an automatic backup (automated) or was created manually (manual)."
  value       = aws_memorydb_snapshot.this.source
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_memorydb_snapshot.this.tags_all
}