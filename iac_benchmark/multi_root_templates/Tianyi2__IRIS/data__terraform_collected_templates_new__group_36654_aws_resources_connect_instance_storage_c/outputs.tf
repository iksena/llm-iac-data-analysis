output "association_id" {
  description = "The existing association identifier that uniquely identifies the resource type and storage config for the given instance ID"
  value       = aws_connect_instance_storage_config.this.association_id
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance, association_id, and resource_type separated by a colon (:)"
  value       = aws_connect_instance_storage_config.this.id
}