output "arn" {
  description = "Amazon Resource Name of the file system."
  value       = data.aws_fsx_ontap_file_system.this.arn
}

output "automatic_backup_retention_days" {
  description = "The number of days to retain automatic backups."
  value       = data.aws_fsx_ontap_file_system.this.automatic_backup_retention_days
}

output "daily_automatic_backup_start_time" {
  description = "The preferred time (in HH:MM format) to take daily automatic backups, in the UTC time zone."
  value       = data.aws_fsx_ontap_file_system.this.daily_automatic_backup_start_time
}

output "deployment_type" {
  description = "The file system deployment type."
  value       = data.aws_fsx_ontap_file_system.this.deployment_type
}

output "disk_iops_configuration" {
  description = "The SSD IOPS configuration for the Amazon FSx for NetApp ONTAP file system, specifying the number of provisioned IOPS and the provision mode."
  value       = data.aws_fsx_ontap_file_system.this.disk_iops_configuration
}

output "dns_name" {
  description = "DNS name for the file system. Note: This attribute does not apply to FSx for ONTAP file systems and is consequently not set."
  value       = data.aws_fsx_ontap_file_system.this.dns_name
}

output "endpoint_ip_address_range" {
  description = "(Multi-AZ only) Specifies the IP address range in which the endpoints to access your file system exist."
  value       = data.aws_fsx_ontap_file_system.this.endpoint_ip_address_range
}

output "endpoints" {
  description = "The Management and Intercluster FileSystemEndpoints that are used to access data or to manage the file system using the NetApp ONTAP CLI, REST API, or NetApp SnapMirror."
  value       = data.aws_fsx_ontap_file_system.this.endpoints
}

output "ha_pairs" {
  description = "The number of HA pairs for the file system."
  value       = data.aws_fsx_ontap_file_system.this.ha_pairs
}

output "id" {
  description = "Identifier of the file system (e.g. fs-12345678)."
  value       = data.aws_fsx_ontap_file_system.this.id
}

output "kms_key_id" {
  description = "ARN for the KMS Key to encrypt the file system at rest."
  value       = data.aws_fsx_ontap_file_system.this.kms_key_id
}

output "network_interface_ids" {
  description = "The IDs of the elastic network interfaces from which a specific file system is accessible."
  value       = data.aws_fsx_ontap_file_system.this.network_interface_ids
}

output "owner_id" {
  description = "AWS account identifier that created the file system."
  value       = data.aws_fsx_ontap_file_system.this.owner_id
}

output "preferred_subnet_id" {
  description = "Specifies the subnet in which you want the preferred file server to be located."
  value       = data.aws_fsx_ontap_file_system.this.preferred_subnet_id
}

output "route_table_ids" {
  description = "(Multi-AZ only) The VPC route tables in which your file system's endpoints exist."
  value       = data.aws_fsx_ontap_file_system.this.route_table_ids
}

output "storage_capacity" {
  description = "The storage capacity of the file system in gibibytes (GiB)."
  value       = data.aws_fsx_ontap_file_system.this.storage_capacity
}

output "storage_type" {
  description = "The type of storage the file system is using. If set to SSD, the file system uses solid state drive storage. If set to HDD, the file system uses hard disk drive storage."
  value       = data.aws_fsx_ontap_file_system.this.storage_type
}

output "subnet_ids" {
  description = "Specifies the IDs of the subnets that the file system is accessible from."
  value       = data.aws_fsx_ontap_file_system.this.subnet_ids
}

output "tags" {
  description = "The tags associated with the file system."
  value       = data.aws_fsx_ontap_file_system.this.tags
}

output "throughput_capacity" {
  description = "The sustained throughput of an Amazon FSx file system in Megabytes per second (MBps)."
  value       = data.aws_fsx_ontap_file_system.this.throughput_capacity
}

output "throughput_capacity_per_ha_pair" {
  description = "The sustained throughput of each HA pair for an Amazon FSx file system in Megabytes per second (MBps)."
  value       = data.aws_fsx_ontap_file_system.this.throughput_capacity_per_ha_pair
}

output "vpc_id" {
  description = "The ID of the primary virtual private cloud (VPC) for the file system."
  value       = data.aws_fsx_ontap_file_system.this.vpc_id
}

output "weekly_maintenance_start_time" {
  description = "The preferred start time (in D:HH:MM format) to perform weekly maintenance, in the UTC time zone."
  value       = data.aws_fsx_ontap_file_system.this.weekly_maintenance_start_time
}