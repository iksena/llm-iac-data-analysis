output "id" {
  description = "ID of the access point."
  value       = data.aws_efs_access_point.this.id
}

output "arn" {
  description = "Amazon Resource Name of the file system."
  value       = data.aws_efs_access_point.this.arn
}

output "file_system_arn" {
  description = "Amazon Resource Name of the file system."
  value       = data.aws_efs_access_point.this.file_system_arn
}

output "file_system_id" {
  description = "ID of the file system for which the access point is intended."
  value       = data.aws_efs_access_point.this.file_system_id
}

output "posix_user" {
  description = "Single element list containing operating system user and group applied to all file system requests made using the access point."
  value       = data.aws_efs_access_point.this.posix_user
}

output "root_directory" {
  description = "Single element list containing information on the directory on the Amazon EFS file system that the access point provides access to."
  value       = data.aws_efs_access_point.this.root_directory
}

output "tags" {
  description = "Key-value mapping of resource tags."
  value       = data.aws_efs_access_point.this.tags
}