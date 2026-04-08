output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_redshift_orderable_cluster.this.region
}

output "cluster_type" {
  description = "Redshift Cluster type"
  value       = data.aws_redshift_orderable_cluster.this.cluster_type
}

output "cluster_version" {
  description = "Redshift Cluster version"
  value       = data.aws_redshift_orderable_cluster.this.cluster_version
}

output "node_type" {
  description = "Redshift Cluster node type"
  value       = data.aws_redshift_orderable_cluster.this.node_type
}

output "preferred_node_types" {
  description = "Ordered list of preferred Redshift Cluster node types"
  value       = data.aws_redshift_orderable_cluster.this.preferred_node_types
}

output "availability_zones" {
  description = "List of Availability Zone names where the Redshift Cluster is available"
  value       = data.aws_redshift_orderable_cluster.this.availability_zones
}