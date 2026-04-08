output "arn" {
  description = "ARN of the access point"
  value       = aws_efs_access_point.this.arn
}

output "file_system_arn" {
  description = "ARN of the file system"
  value       = aws_efs_access_point.this.file_system_arn
}

output "id" {
  description = "ID of the access point"
  value       = aws_efs_access_point.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_efs_access_point.this.tags_all
}