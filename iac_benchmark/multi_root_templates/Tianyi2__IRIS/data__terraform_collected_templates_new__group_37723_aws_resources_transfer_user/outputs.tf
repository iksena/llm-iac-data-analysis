output "arn" {
  description = "Amazon Resource Name (ARN) of Transfer User"
  value       = aws_transfer_user.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_transfer_user.this.tags_all
}

output "server_id" {
  description = "The Server ID of the Transfer Server"
  value       = aws_transfer_user.this.server_id
}

output "user_name" {
  description = "The name used for log in to your SFTP server"
  value       = aws_transfer_user.this.user_name
}

output "role" {
  description = "Amazon Resource Name (ARN) of an IAM role that allows the service to control your user's access to your Amazon S3 bucket"
  value       = aws_transfer_user.this.role
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_transfer_user.this.region
}

output "home_directory" {
  description = "The landing directory (folder) for a user when they log in to the server using their SFTP client"
  value       = aws_transfer_user.this.home_directory
}

output "home_directory_mappings" {
  description = "Logical directory mappings that specify what S3 paths and keys should be visible to your user and how you want to make them visible"
  value       = aws_transfer_user.this.home_directory_mappings
}

output "home_directory_type" {
  description = "The type of landing directory (folder) you mapped for your users' home directory"
  value       = aws_transfer_user.this.home_directory_type
}

output "policy" {
  description = "An IAM JSON policy document that scopes down user access to portions of their Amazon S3 bucket"
  value       = aws_transfer_user.this.policy
}

output "posix_profile" {
  description = "Specifies the full POSIX identity, including user ID (Uid), group ID (Gid), and any secondary groups IDs (SecondaryGids), that controls your users' access to your Amazon EFS file systems"
  value       = aws_transfer_user.this.posix_profile
}

output "tags" {
  description = "A map of tags to assign to the resource"
  value       = aws_transfer_user.this.tags
}