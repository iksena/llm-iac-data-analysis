output "active_directory_id" {
  description = "The ID for Microsoft Active Directory instance that the file system is join to."
  value       = data.aws_fsx_windows_file_system.this.active_directory_id
}

output "aliases" {
  description = "An array DNS alias names associated with the Amazon FSx file system."
  value       = data.aws_fsx_windows_file_system.this.aliases
}

output "arn" {
  description = "Amazon Resource Name of the file system."
  value       = data.aws_fsx_windows_file_system.this.arn
}

output "audit_log_configuration" {
  description = "The configuration that Amazon FSx for Windows File Server uses to audit and log user accesses of files, folders, and file shares on the Amazon FSx for Windows File Server file system."
  value       = data.aws_fsx_windows_file_system.this.audit_log_configuration
}

output "automatic_backup_retention_days" {
  description = "The number of days to retain automatic backups."
  value       = data.aws_fsx_windows_file_system.this.automatic_backup_retention_days
}

output "copy_tags_to_backups" {
  description = "A boolean flag indicating whether tags on the file system should be copied to backups."
  value       = data.aws_fsx_windows_file_system.this.copy_tags_to_backups
}

output "daily_automatic_backup_start_time" {
  description = "The preferred time (in HH:MM format) to take daily automatic backups, in the UTC time zone."
  value       = data.aws_fsx_windows_file_system.this.daily_automatic_backup_start_time
}

output "deployment_type" {
  description = "The file system deployment type."
  value       = data.aws_fsx_windows_file_system.this.deployment_type
}

output "disk_iops_configuration" {
  description = "The SSD IOPS configuration for the file system."
  value       = data.aws_fsx_windows_file_system.this.disk_iops_configuration
}

output "dns_name" {
  description = "DNS name for the file system (e.g. fs-12345678.corp.example.com)."
  value       = data.aws_fsx_windows_file_system.this.dns_name
}

output "id" {
  description = "Identifier of the file system (e.g. fs-12345678)."
  value       = data.aws_fsx_windows_file_system.this.id
}

output "kms_key_id" {
  description = "ARN for the KMS Key to encrypt the file system at rest."
  value       = data.aws_fsx_windows_file_system.this.kms_key_id
}

output "owner_id" {
  description = "AWS account identifier that created the file system."
  value       = data.aws_fsx_windows_file_system.this.owner_id
}

output "preferred_subnet_id" {
  description = "Specifies the subnet in which you want the preferred file server to be located."
  value       = data.aws_fsx_windows_file_system.this.preferred_subnet_id
}

output "preferred_file_server_ip" {
  description = "The IP address of the primary, or preferred, file server."
  value       = data.aws_fsx_windows_file_system.this.preferred_file_server_ip
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_fsx_windows_file_system.this.region
}

output "storage_capacity" {
  description = "The storage capacity of the file system in gibibytes (GiB)."
  value       = data.aws_fsx_windows_file_system.this.storage_capacity
}

output "storage_type" {
  description = "The type of storage the file system is using. If set to SSD, the file system uses solid state drive storage. If set to HDD, the file system uses hard disk drive storage."
  value       = data.aws_fsx_windows_file_system.this.storage_type
}

output "subnet_ids" {
  description = "Specifies the IDs of the subnets that the file system is accessible from."
  value       = data.aws_fsx_windows_file_system.this.subnet_ids
}

output "tags" {
  description = "The tags to associate with the file system."
  value       = data.aws_fsx_windows_file_system.this.tags
}

output "throughput_capacity" {
  description = "Throughput (megabytes per second) of the file system in power of 2 increments. Minimum of 8 and maximum of 2048."
  value       = data.aws_fsx_windows_file_system.this.throughput_capacity
}

output "vpc_id" {
  description = "The ID of the primary virtual private cloud (VPC) for the file system."
  value       = data.aws_fsx_windows_file_system.this.vpc_id
}

output "weekly_maintenance_start_time" {
  description = "The preferred start time (in d:HH:MM format) to perform weekly maintenance, in the UTC time zone."
  value       = data.aws_fsx_windows_file_system.this.weekly_maintenance_start_time
}