output "replication_instance_arn" {
  description = "The Amazon Resource Name (ARN) of the replication instance."
  value       = aws_dms_replication_instance.this.replication_instance_arn
}

output "replication_instance_private_ips" {
  description = "A list of the private IP addresses of the replication instance."
  value       = aws_dms_replication_instance.this.replication_instance_private_ips
}

output "replication_instance_public_ips" {
  description = "A list of the public IP addresses of the replication instance."
  value       = aws_dms_replication_instance.this.replication_instance_public_ips
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_dms_replication_instance.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_dms_replication_instance.this.region
}

output "allocated_storage" {
  description = "The amount of storage (in gigabytes) allocated for the replication instance."
  value       = aws_dms_replication_instance.this.allocated_storage
}

output "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed."
  value       = aws_dms_replication_instance.this.allow_major_version_upgrade
}

output "apply_immediately" {
  description = "Indicates whether the changes should be applied immediately or during the next maintenance window."
  value       = aws_dms_replication_instance.this.apply_immediately
}

output "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the replication instance during the maintenance window."
  value       = aws_dms_replication_instance.this.auto_minor_version_upgrade
}

output "availability_zone" {
  description = "The EC2 Availability Zone that the replication instance is created in."
  value       = aws_dms_replication_instance.this.availability_zone
}

output "dns_name_servers" {
  description = "A list of custom DNS name servers supported for the replication instance."
  value       = aws_dms_replication_instance.this.dns_name_servers
}

output "engine_version" {
  description = "The engine version number of the replication instance."
  value       = aws_dms_replication_instance.this.engine_version
}

output "kerberos_authentication_settings" {
  description = "Configuration block for settings required for Kerberos authentication."
  value       = aws_dms_replication_instance.this.kerberos_authentication_settings
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) for the KMS key used to encrypt the connection parameters."
  value       = aws_dms_replication_instance.this.kms_key_arn
}

output "multi_az" {
  description = "Specifies if the replication instance is a multi-az deployment."
  value       = aws_dms_replication_instance.this.multi_az
}

output "network_type" {
  description = "The type of IP address protocol used by the replication instance."
  value       = aws_dms_replication_instance.this.network_type
}

output "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur."
  value       = aws_dms_replication_instance.this.preferred_maintenance_window
}

output "publicly_accessible" {
  description = "Specifies the accessibility options for the replication instance."
  value       = aws_dms_replication_instance.this.publicly_accessible
}

output "replication_instance_class" {
  description = "The compute and memory capacity of the replication instance."
  value       = aws_dms_replication_instance.this.replication_instance_class
}

output "replication_instance_id" {
  description = "The replication instance identifier."
  value       = aws_dms_replication_instance.this.replication_instance_id
}

output "replication_subnet_group_id" {
  description = "A subnet group associated with the replication instance."
  value       = aws_dms_replication_instance.this.replication_subnet_group_id
}

output "tags" {
  description = "A map of tags assigned to the resource."
  value       = aws_dms_replication_instance.this.tags
}

output "vpc_security_group_ids" {
  description = "A list of VPC security group IDs used with the replication instance."
  value       = aws_dms_replication_instance.this.vpc_security_group_ids
}