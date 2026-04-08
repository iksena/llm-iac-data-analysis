output "arn" {
  description = "Amazon Resource Name of the file system."
  value       = aws_efs_file_system.this.arn
}

output "availability_zone_id" {
  description = "The identifier of the Availability Zone in which the file system's One Zone storage classes exist."
  value       = aws_efs_file_system.this.availability_zone_id
}

output "id" {
  description = "The ID that identifies the file system (e.g., fs-ccfc0d65)."
  value       = aws_efs_file_system.this.id
}

output "dns_name" {
  description = "The DNS name for the filesystem per documented convention."
  value       = aws_efs_file_system.this.dns_name
}

output "name" {
  description = "The value of the file system's Name tag."
  value       = aws_efs_file_system.this.name
}

output "number_of_mount_targets" {
  description = "The current number of mount targets that the file system has."
  value       = aws_efs_file_system.this.number_of_mount_targets
}

output "owner_id" {
  description = "The AWS account that created the file system. If the file system was created by an IAM user, the parent account to which the user belongs is the owner."
  value       = aws_efs_file_system.this.owner_id
}

output "size_in_bytes" {
  description = "The latest known metered size (in bytes) of data stored in the file system, the value is not the exact size that the file system was at any point in time."
  value       = aws_efs_file_system.this.size_in_bytes
}

output "size_in_bytes_value" {
  description = "The latest known metered size (in bytes) of data stored in the file system."
  value       = try(aws_efs_file_system.this.size_in_bytes[0].value, null)
}

output "size_in_bytes_value_in_ia" {
  description = "The latest known metered size (in bytes) of data stored in the Infrequent Access storage class."
  value       = try(aws_efs_file_system.this.size_in_bytes[0].value_in_ia, null)
}

output "size_in_bytes_value_in_standard" {
  description = "The latest known metered size (in bytes) of data stored in the Standard storage class."
  value       = try(aws_efs_file_system.this.size_in_bytes[0].value_in_standard, null)
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_efs_file_system.this.tags_all
}