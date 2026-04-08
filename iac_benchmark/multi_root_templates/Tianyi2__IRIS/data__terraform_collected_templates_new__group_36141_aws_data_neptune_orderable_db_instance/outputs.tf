output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_neptune_orderable_db_instance.this.region
}

output "engine" {
  description = "DB engine."
  value       = data.aws_neptune_orderable_db_instance.this.engine
}

output "engine_version" {
  description = "Version of the DB engine."
  value       = data.aws_neptune_orderable_db_instance.this.engine_version
}

output "instance_class" {
  description = "DB instance class."
  value       = data.aws_neptune_orderable_db_instance.this.instance_class
}

output "license_model" {
  description = "License model."
  value       = data.aws_neptune_orderable_db_instance.this.license_model
}

output "preferred_instance_classes" {
  description = "Ordered list of preferred Neptune DB instance classes."
  value       = data.aws_neptune_orderable_db_instance.this.preferred_instance_classes
}

output "vpc" {
  description = "Enable to show only VPC offerings."
  value       = data.aws_neptune_orderable_db_instance.this.vpc
}

output "availability_zones" {
  description = "Availability zones where the instance is available."
  value       = data.aws_neptune_orderable_db_instance.this.availability_zones
}

output "max_iops_per_db_instance" {
  description = "Maximum total provisioned IOPS for a DB instance."
  value       = data.aws_neptune_orderable_db_instance.this.max_iops_per_db_instance
}

output "max_iops_per_gib" {
  description = "Maximum provisioned IOPS per GiB for a DB instance."
  value       = data.aws_neptune_orderable_db_instance.this.max_iops_per_gib
}

output "max_storage_size" {
  description = "Maximum storage size for a DB instance."
  value       = data.aws_neptune_orderable_db_instance.this.max_storage_size
}

output "min_iops_per_db_instance" {
  description = "Minimum total provisioned IOPS for a DB instance."
  value       = data.aws_neptune_orderable_db_instance.this.min_iops_per_db_instance
}

output "min_iops_per_gib" {
  description = "Minimum provisioned IOPS per GiB for a DB instance."
  value       = data.aws_neptune_orderable_db_instance.this.min_iops_per_gib
}

output "min_storage_size" {
  description = "Minimum storage size for a DB instance."
  value       = data.aws_neptune_orderable_db_instance.this.min_storage_size
}

output "multi_az_capable" {
  description = "Whether a DB instance is Multi-AZ capable."
  value       = data.aws_neptune_orderable_db_instance.this.multi_az_capable
}

output "read_replica_capable" {
  description = "Whether a DB instance can have a read replica."
  value       = data.aws_neptune_orderable_db_instance.this.read_replica_capable
}

output "storage_type" {
  description = "Storage type for a DB instance."
  value       = data.aws_neptune_orderable_db_instance.this.storage_type
}

output "supports_enhanced_monitoring" {
  description = "Whether a DB instance supports Enhanced Monitoring at intervals from 1 to 60 seconds."
  value       = data.aws_neptune_orderable_db_instance.this.supports_enhanced_monitoring
}

output "supports_iam_database_authentication" {
  description = "Whether a DB instance supports IAM database authentication."
  value       = data.aws_neptune_orderable_db_instance.this.supports_iam_database_authentication
}

output "supports_iops" {
  description = "Whether a DB instance supports provisioned IOPS."
  value       = data.aws_neptune_orderable_db_instance.this.supports_iops
}

output "supports_performance_insights" {
  description = "Whether a DB instance supports Performance Insights."
  value       = data.aws_neptune_orderable_db_instance.this.supports_performance_insights
}

output "supports_storage_encryption" {
  description = "Whether a DB instance supports encrypted storage."
  value       = data.aws_neptune_orderable_db_instance.this.supports_storage_encryption
}