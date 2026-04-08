output "allocated_storage" {
  description = "The amount of storage (in gigabytes) to be initially allocated for the replication instance."
  value       = data.aws_dms_replication_instance.this.allocated_storage
}

output "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the replication instance during the maintenance window."
  value       = data.aws_dms_replication_instance.this.auto_minor_version_upgrade
}

output "availability_zone" {
  description = "The EC2 Availability Zone that the replication instance will be created in."
  value       = data.aws_dms_replication_instance.this.availability_zone
}

output "engine_version" {
  description = "The engine version number of the replication instance."
  value       = data.aws_dms_replication_instance.this.engine_version
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) for the KMS key used to encrypt the connection parameters."
  value       = data.aws_dms_replication_instance.this.kms_key_arn
}

output "multi_az" {
  description = "Specifies if the replication instance is a multi-az deployment."
  value       = data.aws_dms_replication_instance.this.multi_az
}

output "network_type" {
  description = "The type of IP address protocol used by the replication instance."
  value       = data.aws_dms_replication_instance.this.network_type
}

output "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur, in Universal Coordinated Time (UTC)."
  value       = data.aws_dms_replication_instance.this.preferred_maintenance_window
}

output "publicly_accessible" {
  description = "Specifies the accessibility options for the replication instance. A value of true represents an instance with a public IP address. A value of false represents an instance with a private IP address."
  value       = data.aws_dms_replication_instance.this.publicly_accessible
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_dms_replication_instance.this.region
}

output "replication_instance_arn" {
  description = "The Amazon Resource Name (ARN) of the replication instance."
  value       = data.aws_dms_replication_instance.this.replication_instance_arn
}

output "replication_instance_class" {
  description = "The compute and memory capacity of the replication instance as specified by the replication instance class."
  value       = data.aws_dms_replication_instance.this.replication_instance_class
}

output "replication_instance_id" {
  description = "The replication instance identifier."
  value       = data.aws_dms_replication_instance.this.replication_instance_id
}

output "replication_instance_private_ips" {
  description = "A list of the private IP addresses of the replication instance."
  value       = data.aws_dms_replication_instance.this.replication_instance_private_ips
}

output "replication_instance_public_ips" {
  description = "A list of the public IP addresses of the replication instance."
  value       = data.aws_dms_replication_instance.this.replication_instance_public_ips
}

output "replication_subnet_group_id" {
  description = "A subnet group to associate with the replication instance."
  value       = data.aws_dms_replication_instance.this.replication_subnet_group_id
}

output "vpc_security_group_ids" {
  description = "A set of VPC security group IDs that are used with the replication instance."
  value       = data.aws_dms_replication_instance.this.vpc_security_group_ids
}