output "id" {
  description = "The ID of the EventBridge Schemas Registry Policy"
  value       = aws_schemas_registry_policy.this.id
}

output "registry_name" {
  description = "Name of EventBridge Schema Registry"
  value       = aws_schemas_registry_policy.this.registry_name
}

output "policy" {
  description = "Resource Policy for EventBridge Schema Registry"
  value       = aws_schemas_registry_policy.this.policy
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_schemas_registry_policy.this.region
}