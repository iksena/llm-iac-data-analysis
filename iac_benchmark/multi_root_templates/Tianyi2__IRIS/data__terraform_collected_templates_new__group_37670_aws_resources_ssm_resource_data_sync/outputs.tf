output "id" {
  description = "The identifier of the SSM resource data sync."
  value       = aws_ssm_resource_data_sync.this.id
}

output "name" {
  description = "The name of the SSM resource data sync."
  value       = aws_ssm_resource_data_sync.this.name
}

output "s3_destination" {
  description = "The S3 destination configuration for the SSM resource data sync."
  value       = aws_ssm_resource_data_sync.this.s3_destination
}