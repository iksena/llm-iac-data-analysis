output "arn" {
  description = "ARN of cluster"
  value       = data.aws_redshift_cluster.this.arn
}

output "allow_version_upgrade" {
  description = "Whether major version upgrades can be applied during maintenance period"
  value       = data.aws_redshift_cluster.this.allow_version_upgrade
}

output "automated_snapshot_retention_period" {
  description = "The backup retention period"
  value       = data.aws_redshift_cluster.this.automated_snapshot_retention_period
}

output "aqua_configuration_status" {
  description = "The value represents how the cluster is configured to use AQUA"
  value       = data.aws_redshift_cluster.this.aqua_configuration_status
}

output "availability_zone" {
  description = "Availability zone of the cluster"
  value       = data.aws_redshift_cluster.this.availability_zone
}

output "availability_zone_relocation_enabled" {
  description = "Indicates whether the cluster is able to be relocated to another availability zone"
  value       = data.aws_redshift_cluster.this.availability_zone_relocation_enabled
}

output "bucket_name" {
  description = "Name of the S3 bucket where the log files are to be stored"
  value       = data.aws_redshift_cluster.this.bucket_name
}

output "cluster_identifier" {
  description = "Cluster identifier"
  value       = data.aws_redshift_cluster.this.cluster_identifier
}

output "cluster_nodes" {
  description = "Nodes in the cluster"
  value       = data.aws_redshift_cluster.this.cluster_nodes
}

output "cluster_parameter_group_name" {
  description = "The name of the parameter group to be associated with this cluster"
  value       = data.aws_redshift_cluster.this.cluster_parameter_group_name
}

output "cluster_public_key" {
  description = "Public key for the cluster"
  value       = data.aws_redshift_cluster.this.cluster_public_key
}

output "cluster_revision_number" {
  description = "The cluster revision number"
  value       = data.aws_redshift_cluster.this.cluster_revision_number
}

output "cluster_subnet_group_name" {
  description = "The name of a cluster subnet group to be associated with this cluster"
  value       = data.aws_redshift_cluster.this.cluster_subnet_group_name
}

output "cluster_type" {
  description = "Cluster type"
  value       = data.aws_redshift_cluster.this.cluster_type
}

output "cluster_namespace_arn" {
  description = "The namespace Amazon Resource Name (ARN) of the cluster"
  value       = data.aws_redshift_cluster.this.cluster_namespace_arn
}

output "database_name" {
  description = "Name of the default database in the cluster"
  value       = data.aws_redshift_cluster.this.database_name
}

output "default_iam_role_arn" {
  description = "The ARN for the IAM role that was set as default for the cluster when the cluster was created"
  value       = data.aws_redshift_cluster.this.default_iam_role_arn
}

output "elastic_ip" {
  description = "Elastic IP of the cluster"
  value       = data.aws_redshift_cluster.this.elastic_ip
}

output "enable_logging" {
  description = "Whether cluster logging is enabled"
  value       = data.aws_redshift_cluster.this.enable_logging
}

output "encrypted" {
  description = "Whether the cluster data is encrypted"
  value       = data.aws_redshift_cluster.this.encrypted
}

output "endpoint" {
  description = "Cluster endpoint"
  value       = data.aws_redshift_cluster.this.endpoint
}

output "enhanced_vpc_routing" {
  description = "Whether enhanced VPC routing is enabled"
  value       = data.aws_redshift_cluster.this.enhanced_vpc_routing
}

output "iam_roles" {
  description = "IAM roles associated to the cluster"
  value       = data.aws_redshift_cluster.this.iam_roles
}

output "kms_key_id" {
  description = "KMS encryption key associated to the cluster"
  value       = data.aws_redshift_cluster.this.kms_key_id
}

output "master_username" {
  description = "Username for the master DB user"
  value       = data.aws_redshift_cluster.this.master_username
}

output "multi_az" {
  description = "If the cluster is a Multi-AZ deployment"
  value       = data.aws_redshift_cluster.this.multi_az
}

output "node_type" {
  description = "Cluster node type"
  value       = data.aws_redshift_cluster.this.node_type
}

output "number_of_nodes" {
  description = "Number of nodes in the cluster"
  value       = data.aws_redshift_cluster.this.number_of_nodes
}

output "maintenance_track_name" {
  description = "The name of the maintenance track for the restored cluster"
  value       = data.aws_redshift_cluster.this.maintenance_track_name
}

output "manual_snapshot_retention_period" {
  description = "The default number of days to retain a manual snapshot"
  value       = data.aws_redshift_cluster.this.manual_snapshot_retention_period
}

output "port" {
  description = "Port the cluster responds on"
  value       = data.aws_redshift_cluster.this.port
}

output "preferred_maintenance_window" {
  description = "The maintenance window"
  value       = data.aws_redshift_cluster.this.preferred_maintenance_window
}

output "publicly_accessible" {
  description = "Whether the cluster is publicly accessible"
  value       = data.aws_redshift_cluster.this.publicly_accessible
}

output "s3_key_prefix" {
  description = "Folder inside the S3 bucket where the log files are stored"
  value       = data.aws_redshift_cluster.this.s3_key_prefix
}

output "log_destination_type" {
  description = "The log destination type"
  value       = data.aws_redshift_cluster.this.log_destination_type
}

output "log_exports" {
  description = "Collection of exported log types. Log types include the connection log, user log and user activity log"
  value       = data.aws_redshift_cluster.this.log_exports
}

output "tags" {
  description = "Tags associated to the cluster"
  value       = data.aws_redshift_cluster.this.tags
}

output "vpc_id" {
  description = "VPC Id associated with the cluster"
  value       = data.aws_redshift_cluster.this.vpc_id
}

output "vpc_security_group_ids" {
  description = "The VPC security group Ids associated with the cluster"
  value       = data.aws_redshift_cluster.this.vpc_security_group_ids
}