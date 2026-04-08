output "file_system_arn" {
  description = "Amazon Resource Name of the file system for which the mount target is intended"
  value       = data.aws_efs_mount_target.this.file_system_arn
}

output "subnet_id" {
  description = "ID of the mount target's subnet"
  value       = data.aws_efs_mount_target.this.subnet_id
}

output "ip_address" {
  description = "Address at which the file system may be mounted via the mount target"
  value       = data.aws_efs_mount_target.this.ip_address
}

output "ip_address_type" {
  description = "IP address type for the mount target"
  value       = data.aws_efs_mount_target.this.ip_address_type
}

output "ipv6_address" {
  description = "IPv6 address at which the file system may be mounted via the mount target"
  value       = data.aws_efs_mount_target.this.ipv6_address
}

output "security_groups" {
  description = "List of VPC security group IDs attached to the mount target"
  value       = data.aws_efs_mount_target.this.security_groups
}

output "dns_name" {
  description = "DNS name for the EFS file system"
  value       = data.aws_efs_mount_target.this.dns_name
}

output "mount_target_dns_name" {
  description = "The DNS name for the given subnet/AZ per documented convention"
  value       = data.aws_efs_mount_target.this.mount_target_dns_name
}

output "network_interface_id" {
  description = "The ID of the network interface that Amazon EFS created when it created the mount target"
  value       = data.aws_efs_mount_target.this.network_interface_id
}

output "availability_zone_name" {
  description = "The name of the Availability Zone (AZ) that the mount target resides in"
  value       = data.aws_efs_mount_target.this.availability_zone_name
}

output "availability_zone_id" {
  description = "The unique and consistent identifier of the Availability Zone (AZ) that the mount target resides in"
  value       = data.aws_efs_mount_target.this.availability_zone_id
}

output "owner_id" {
  description = "AWS account ID that owns the resource"
  value       = data.aws_efs_mount_target.this.owner_id
}