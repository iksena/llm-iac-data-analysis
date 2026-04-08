output "arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = aws_redshift_cluster.this.arn
}

output "id" {
  description = "The Redshift Cluster ID"
  value       = aws_redshift_cluster.this.id
}

output "cluster_identifier" {
  description = "The Cluster Identifier"
  value       = aws_redshift_cluster.this.cluster_identifier
}

output "cluster_type" {
  description = "The cluster type"
  value       = aws_redshift_cluster.this.cluster_type
}

output "node_type" {
  description = "The type of nodes in the cluster"
  value       = aws_redshift_cluster.this.node_type
}

output "database_name" {
  description = "The name of the default database in the Cluster"
  value       = aws_redshift_cluster.this.database_name
}

output "availability_zone" {
  description = "The availability zone of the Cluster"
  value       = aws_redshift_cluster.this.availability_zone
}

output "automated_snapshot_retention_period" {
  description = "The backup retention period"
  value       = aws_redshift_cluster.this.automated_snapshot_retention_period
}

output "preferred_maintenance_window" {
  description = "The backup window"
  value       = aws_redshift_cluster.this.preferred_maintenance_window
}

output "endpoint" {
  description = "The connection endpoint"
  value       = aws_redshift_cluster.this.endpoint
}

output "encrypted" {
  description = "Whether the data in the cluster is encrypted"
  value       = aws_redshift_cluster.this.encrypted
}

output "vpc_security_group_ids" {
  description = "The VPC security group Ids associated with the cluster"
  value       = aws_redshift_cluster.this.vpc_security_group_ids
}

output "dns_name" {
  description = "The DNS name of the cluster"
  value       = aws_redshift_cluster.this.dns_name
}

output "master_password_secret_arn" {
  description = "ARN of the cluster admin credentials secret"
  value       = aws_redshift_cluster.this.master_password_secret_arn
  sensitive   = true
}

output "port" {
  description = "The Port the cluster responds on"
  value       = aws_redshift_cluster.this.port
}

output "cluster_version" {
  description = "The version of Redshift engine software"
  value       = aws_redshift_cluster.this.cluster_version
}

output "cluster_parameter_group_name" {
  description = "The name of the parameter group to be associated with this cluster"
  value       = aws_redshift_cluster.this.cluster_parameter_group_name
}

output "cluster_subnet_group_name" {
  description = "The name of a cluster subnet group to be associated with this cluster"
  value       = aws_redshift_cluster.this.cluster_subnet_group_name
}

output "cluster_public_key" {
  description = "The public key for the cluster"
  value       = aws_redshift_cluster.this.cluster_public_key
}

output "cluster_revision_number" {
  description = "The specific revision number of the database in the cluster"
  value       = aws_redshift_cluster.this.cluster_revision_number
}

output "cluster_nodes" {
  description = "The nodes in the cluster"
  value       = aws_redshift_cluster.this.cluster_nodes
}

output "cluster_namespace_arn" {
  description = "The namespace Amazon Resource Name (ARN) of the cluster"
  value       = aws_redshift_cluster.this.cluster_namespace_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_redshift_cluster.this.tags_all
}