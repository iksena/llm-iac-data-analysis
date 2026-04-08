output "id" {
  description = "Amazon Resource Name (ARN) of the FSx file system association"
  value       = aws_storagegateway_file_system_association.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the newly created file system association."
  value       = aws_storagegateway_file_system_association.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_storagegateway_file_system_association.this.tags_all
}