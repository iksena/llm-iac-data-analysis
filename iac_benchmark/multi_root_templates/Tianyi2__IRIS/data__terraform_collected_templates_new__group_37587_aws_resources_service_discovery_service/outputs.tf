output "id" {
  description = "The ID of the service."
  value       = aws_service_discovery_service.this.id
}

output "arn" {
  description = "The ARN of the service."
  value       = aws_service_discovery_service.this.arn
}

output "name" {
  description = "The name of the service."
  value       = aws_service_discovery_service.this.name
}

output "description" {
  description = "The description of the service."
  value       = aws_service_discovery_service.this.description
}

output "namespace_id" {
  description = "The ID of the namespace that you want to use to create the service."
  value       = aws_service_discovery_service.this.namespace_id
}

output "type" {
  description = "If present, specifies that the service instances are only discoverable using the DiscoverInstances API operation."
  value       = aws_service_discovery_service.this.type
}

output "force_destroy" {
  description = "A boolean that indicates all instances should be deleted from the service so that the service can be destroyed without error."
  value       = aws_service_discovery_service.this.force_destroy
}

output "tags" {
  description = "A map of tags assigned to the service."
  value       = aws_service_discovery_service.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_service_discovery_service.this.tags_all
}