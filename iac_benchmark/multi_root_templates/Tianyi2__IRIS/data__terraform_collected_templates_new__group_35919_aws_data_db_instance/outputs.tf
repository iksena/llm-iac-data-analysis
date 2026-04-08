output "address" {
  description = "Hostname of the RDS instance. See also endpoint and port."
  value       = data.aws_db_instance.this.address
}

output "allocated_storage" {
  description = "Allocated storage size specified in gigabytes."
  value       = data.aws_db_instance.this.allocated_storage
}

output "auto_minor_version_upgrade" {
  description = "Indicates that minor version patches are applied automatically."
  value       = data.aws_db_instance.this.auto_minor_version_upgrade
}

output "availability_zone" {
  description = "Name of the Availability Zone the DB instance is located in."
  value       = data.aws_db_instance.this.availability_zone
}

output "backup_retention_period" {
  description = "Specifies the number of days for which automatic DB snapshots are retained."
  value       = data.aws_db_instance.this.backup_retention_period
}

output "database_insights_mode" {
  description = "The mode of Database Insights that is enabled for the DB instance."
  value       = data.aws_db_instance.this.database_insights_mode
}

output "db_cluster_identifier" {
  description = "If the DB instance is a member of a DB cluster, contains the name of the DB cluster that the DB instance is a member of."
  value       = data.aws_db_instance.this.db_cluster_identifier
}

output "db_instance_arn" {
  description = "ARN for the DB instance."
  value       = data.aws_db_instance.this.db_instance_arn
}

output "db_instance_class" {
  description = "Contains the name of the compute and memory capacity class of the DB instance."
  value       = data.aws_db_instance.this.db_instance_class
}

output "db_name" {
  description = "Contains the name of the initial database of this instance that was provided at create time, if one was specified when the DB instance was created. This same name is returned for the life of the DB instance."
  value       = data.aws_db_instance.this.db_name
}

output "db_parameter_groups" {
  description = "Provides the list of DB parameter groups applied to this DB instance."
  value       = data.aws_db_instance.this.db_parameter_groups
}

output "db_subnet_group" {
  description = "Name of the subnet group associated with the DB instance."
  value       = data.aws_db_instance.this.db_subnet_group
}

output "db_instance_port" {
  description = "Port that the DB instance listens on."
  value       = data.aws_db_instance.this.db_instance_port
}

output "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch."
  value       = data.aws_db_instance.this.enabled_cloudwatch_logs_exports
}

output "endpoint" {
  description = "Connection endpoint in address:port format."
  value       = data.aws_db_instance.this.endpoint
}

output "engine" {
  description = "Provides the name of the database engine to be used for this DB instance."
  value       = data.aws_db_instance.this.engine
}

output "engine_version" {
  description = "Database engine version."
  value       = data.aws_db_instance.this.engine_version
}

output "hosted_zone_id" {
  description = "Canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)."
  value       = data.aws_db_instance.this.hosted_zone_id
}

output "iops" {
  description = "Provisioned IOPS (I/O operations per second) value."
  value       = data.aws_db_instance.this.iops
}

output "kms_key_id" {
  description = "If StorageEncrypted is true, the KMS key identifier for the encrypted DB instance."
  value       = data.aws_db_instance.this.kms_key_id
}

output "license_model" {
  description = "License model information for this DB instance."
  value       = data.aws_db_instance.this.license_model
}

output "master_username" {
  description = "Contains the master username for the DB instance."
  value       = data.aws_db_instance.this.master_username
}

output "master_user_secret" {
  description = "Provides the master user secret. Only available when manage_master_user_password is set to true."
  value       = data.aws_db_instance.this.master_user_secret
}

output "max_allocated_storage" {
  description = "The upper limit to which Amazon RDS can automatically scale the storage of the DB instance."
  value       = data.aws_db_instance.this.max_allocated_storage
}

output "monitoring_interval" {
  description = "Interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance."
  value       = data.aws_db_instance.this.monitoring_interval
}

output "monitoring_role_arn" {
  description = "ARN for the IAM role that permits RDS to send Enhanced Monitoring metrics to CloudWatch Logs."
  value       = data.aws_db_instance.this.monitoring_role_arn
}

output "multi_az" {
  description = "If the DB instance is a Multi-AZ deployment."
  value       = data.aws_db_instance.this.multi_az
}

output "network_type" {
  description = "Network type of the DB instance."
  value       = data.aws_db_instance.this.network_type
}

output "option_group_memberships" {
  description = "Provides the list of option group memberships for this DB instance."
  value       = data.aws_db_instance.this.option_group_memberships
}

output "port" {
  description = "Database endpoint port, primarily used by an Aurora DB cluster. For a conventional RDS DB instance, the db_instance_port is typically the preferred choice."
  value       = data.aws_db_instance.this.port
}

output "preferred_backup_window" {
  description = "Specifies the daily time range during which automated backups are created."
  value       = data.aws_db_instance.this.preferred_backup_window
}

output "preferred_maintenance_window" {
  description = "Specifies the weekly time range during which system maintenance can occur in UTC."
  value       = data.aws_db_instance.this.preferred_maintenance_window
}

output "publicly_accessible" {
  description = "Accessibility options for the DB instance."
  value       = data.aws_db_instance.this.publicly_accessible
}

output "resource_id" {
  description = "RDS Resource ID of this instance."
  value       = data.aws_db_instance.this.resource_id
}

output "storage_encrypted" {
  description = "Whether the DB instance is encrypted."
  value       = data.aws_db_instance.this.storage_encrypted
}

output "storage_throughput" {
  description = "Storage throughput value for the DB instance."
  value       = data.aws_db_instance.this.storage_throughput
}

output "storage_type" {
  description = "Storage type associated with DB instance."
  value       = data.aws_db_instance.this.storage_type
}

output "timezone" {
  description = "Time zone of the DB instance."
  value       = data.aws_db_instance.this.timezone
}

output "vpc_security_groups" {
  description = "Provides a list of VPC security group elements that the DB instance belongs to."
  value       = data.aws_db_instance.this.vpc_security_groups
}

output "replicate_source_db" {
  description = "Identifier of the source DB that this is a replica of."
  value       = data.aws_db_instance.this.replicate_source_db
}

output "ca_cert_identifier" {
  description = "Identifier of the CA certificate for the DB instance."
  value       = data.aws_db_instance.this.ca_cert_identifier
}