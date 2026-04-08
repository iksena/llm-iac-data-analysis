output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_rds_orderable_db_instance.this.region
}

output "availability_zone_group" {
  description = "Availability zone group"
  value       = data.aws_rds_orderable_db_instance.this.availability_zone_group
}

output "engine_latest_version" {
  description = "When set to true, the data source attempts to return the most recent version matching the other criteria"
  value       = data.aws_rds_orderable_db_instance.this.engine_latest_version
}

output "engine_version" {
  description = "Version of the DB engine"
  value       = data.aws_rds_orderable_db_instance.this.engine_version
}

output "engine" {
  description = "DB engine"
  value       = data.aws_rds_orderable_db_instance.this.engine
}

output "instance_class" {
  description = "DB instance class"
  value       = data.aws_rds_orderable_db_instance.this.instance_class
}

output "license_model" {
  description = "License model"
  value       = data.aws_rds_orderable_db_instance.this.license_model
}

output "preferred_engine_versions" {
  description = "Ordered list of preferred RDS DB instance engine versions"
  value       = data.aws_rds_orderable_db_instance.this.preferred_engine_versions
}

output "preferred_instance_classes" {
  description = "Ordered list of preferred RDS DB instance classes"
  value       = data.aws_rds_orderable_db_instance.this.preferred_instance_classes
}

output "read_replica_capable" {
  description = "Whether a DB instance can have a read replica"
  value       = data.aws_rds_orderable_db_instance.this.read_replica_capable
}

output "storage_type" {
  description = "Storage types"
  value       = data.aws_rds_orderable_db_instance.this.storage_type
}

output "supported_engine_modes" {
  description = "Engine modes"
  value       = data.aws_rds_orderable_db_instance.this.supported_engine_modes
}

output "supported_network_types" {
  description = "Network types"
  value       = data.aws_rds_orderable_db_instance.this.supported_network_types
}

output "supports_clusters" {
  description = "Whether instances support clusters"
  value       = data.aws_rds_orderable_db_instance.this.supports_clusters
}

output "supports_multi_az" {
  description = "Whether instances are multi-AZ capable"
  value       = data.aws_rds_orderable_db_instance.this.supports_multi_az
}

output "supports_enhanced_monitoring" {
  description = "Whether DB instance supports Enhanced Monitoring"
  value       = data.aws_rds_orderable_db_instance.this.supports_enhanced_monitoring
}

output "supports_global_databases" {
  description = "Whether DB instance supports Aurora global databases"
  value       = data.aws_rds_orderable_db_instance.this.supports_global_databases
}

output "supports_iam_database_authentication" {
  description = "Whether DB instance supports IAM database authentication"
  value       = data.aws_rds_orderable_db_instance.this.supports_iam_database_authentication
}

output "supports_iops" {
  description = "Whether DB instance supports provisioned IOPS"
  value       = data.aws_rds_orderable_db_instance.this.supports_iops
}

output "supports_kerberos_authentication" {
  description = "Whether DB instance supports Kerberos Authentication"
  value       = data.aws_rds_orderable_db_instance.this.supports_kerberos_authentication
}

output "supports_performance_insights" {
  description = "Whether DB instance supports Performance Insights"
  value       = data.aws_rds_orderable_db_instance.this.supports_performance_insights
}

output "supports_storage_autoscaling" {
  description = "Whether Amazon RDS can automatically scale storage for DB instances"
  value       = data.aws_rds_orderable_db_instance.this.supports_storage_autoscaling
}

output "supports_storage_encryption" {
  description = "Whether DB instance supports encrypted storage"
  value       = data.aws_rds_orderable_db_instance.this.supports_storage_encryption
}

output "vpc" {
  description = "Whether to show only VPC or non-VPC offerings"
  value       = data.aws_rds_orderable_db_instance.this.vpc
}

output "availability_zones" {
  description = "Availability zones where the instance is available"
  value       = data.aws_rds_orderable_db_instance.this.availability_zones
}

output "max_iops_per_db_instance" {
  description = "Maximum total provisioned IOPS for a DB instance"
  value       = data.aws_rds_orderable_db_instance.this.max_iops_per_db_instance
}

output "max_iops_per_gib" {
  description = "Maximum provisioned IOPS per GiB for a DB instance"
  value       = data.aws_rds_orderable_db_instance.this.max_iops_per_gib
}

output "max_storage_size" {
  description = "Maximum storage size for a DB instance"
  value       = data.aws_rds_orderable_db_instance.this.max_storage_size
}

output "min_iops_per_db_instance" {
  description = "Minimum total provisioned IOPS for a DB instance"
  value       = data.aws_rds_orderable_db_instance.this.min_iops_per_db_instance
}

output "min_iops_per_gib" {
  description = "Minimum provisioned IOPS per GiB for a DB instance"
  value       = data.aws_rds_orderable_db_instance.this.min_iops_per_gib
}

output "min_storage_size" {
  description = "Minimum storage size for a DB instance"
  value       = data.aws_rds_orderable_db_instance.this.min_storage_size
}

output "multi_az_capable" {
  description = "Whether a DB instance is Multi-AZ capable"
  value       = data.aws_rds_orderable_db_instance.this.multi_az_capable
}

output "outpost_capable" {
  description = "Whether a DB instance supports RDS on Outposts"
  value       = data.aws_rds_orderable_db_instance.this.outpost_capable
}