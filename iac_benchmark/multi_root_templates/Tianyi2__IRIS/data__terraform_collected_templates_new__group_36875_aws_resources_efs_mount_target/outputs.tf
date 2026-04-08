output "id" {
  description = "The ID of the mount target."
  value       = aws_efs_mount_target.this.id
}

output "dns_name" {
  description = "The DNS name for the EFS file system."
  value       = aws_efs_mount_target.this.dns_name
}

output "mount_target_dns_name" {
  description = "The DNS name for the given subnet/AZ per documented convention."
  value       = aws_efs_mount_target.this.mount_target_dns_name
}

output "file_system_arn" {
  description = "Amazon Resource Name of the file system."
  value       = aws_efs_mount_target.this.file_system_arn
}

output "network_interface_id" {
  description = "The ID of the network interface that Amazon EFS created when it created the mount target."
  value       = aws_efs_mount_target.this.network_interface_id
}

output "availability_zone_name" {
  description = "The name of the Availability Zone (AZ) that the mount target resides in."
  value       = aws_efs_mount_target.this.availability_zone_name
}

output "availability_zone_id" {
  description = "The unique and consistent identifier of the Availability Zone (AZ) that the mount target resides in."
  value       = aws_efs_mount_target.this.availability_zone_id
}

output "owner_id" {
  description = "AWS account ID that owns the resource."
  value       = aws_efs_mount_target.this.owner_id
}