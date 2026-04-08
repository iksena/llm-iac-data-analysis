output "arn" {
  description = "ARN of the broker"
  value       = data.aws_mq_broker.this.arn
}

output "authentication_strategy" {
  description = "Authentication strategy used to secure the broker"
  value       = data.aws_mq_broker.this.authentication_strategy
}

output "auto_minor_version_upgrade" {
  description = "Whether to automatically upgrade to new minor versions of brokers as Amazon MQ makes releases available"
  value       = data.aws_mq_broker.this.auto_minor_version_upgrade
}

output "broker_id" {
  description = "Unique ID of the MQ broker"
  value       = data.aws_mq_broker.this.broker_id
}

output "broker_name" {
  description = "Unique name of the MQ broker"
  value       = data.aws_mq_broker.this.broker_name
}

output "configuration" {
  description = "Configuration block for broker configuration"
  value       = data.aws_mq_broker.this.configuration
}

output "deployment_mode" {
  description = "Deployment mode of the broker"
  value       = data.aws_mq_broker.this.deployment_mode
}

output "encryption_options" {
  description = "Configuration block containing encryption options"
  value       = data.aws_mq_broker.this.encryption_options
}

output "engine_type" {
  description = "Type of broker engine"
  value       = data.aws_mq_broker.this.engine_type
}

output "engine_version" {
  description = "Version of the broker engine"
  value       = data.aws_mq_broker.this.engine_version
}

output "host_instance_type" {
  description = "Broker's instance type"
  value       = data.aws_mq_broker.this.host_instance_type
}

output "instances" {
  description = "List of information about allocated brokers (both active & standby)"
  value       = data.aws_mq_broker.this.instances
}

output "ldap_server_metadata" {
  description = "Configuration block for the LDAP server used to authenticate and authorize connections to the broker"
  value       = data.aws_mq_broker.this.ldap_server_metadata
}

output "logs" {
  description = "Configuration block for the logging configuration of the broker"
  value       = data.aws_mq_broker.this.logs
}

output "maintenance_window_start_time" {
  description = "Configuration block for the maintenance window start time"
  value       = data.aws_mq_broker.this.maintenance_window_start_time
}

output "publicly_accessible" {
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets"
  value       = data.aws_mq_broker.this.publicly_accessible
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_mq_broker.this.region
}

output "security_groups" {
  description = "List of security group IDs assigned to the broker"
  value       = data.aws_mq_broker.this.security_groups
}

output "storage_type" {
  description = "Storage type of the broker"
  value       = data.aws_mq_broker.this.storage_type
}

output "subnet_ids" {
  description = "List of subnet IDs in which to launch the broker"
  value       = data.aws_mq_broker.this.subnet_ids
}

output "tags" {
  description = "Map of tags assigned to the broker"
  value       = data.aws_mq_broker.this.tags
}

output "user" {
  description = "Configuration block for broker users"
  value       = data.aws_mq_broker.this.user
}