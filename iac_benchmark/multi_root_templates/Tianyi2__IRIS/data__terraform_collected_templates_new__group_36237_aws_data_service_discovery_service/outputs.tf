output "id" {
  description = "ID of the service."
  value       = data.aws_service_discovery_service.this.id
}

output "arn" {
  description = "ARN of the service."
  value       = data.aws_service_discovery_service.this.arn
}

output "description" {
  description = "Description of the service."
  value       = data.aws_service_discovery_service.this.description
}

output "dns_config" {
  description = "Complex type that contains information about the resource record sets that you want Amazon Route 53 to create when you register an instance."
  value       = data.aws_service_discovery_service.this.dns_config
}

output "health_check_config" {
  description = "Complex type that contains settings for an optional health check. Only for Public DNS namespaces."
  value       = data.aws_service_discovery_service.this.health_check_config
}

output "health_check_custom_config" {
  description = "A complex type that contains settings for ECS managed health checks."
  value       = data.aws_service_discovery_service.this.health_check_custom_config
}

output "tags" {
  description = "Map of tags to assign to the service."
  value       = data.aws_service_discovery_service.this.tags
}


output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_service_discovery_service.this.region
}

output "name" {
  description = "Name of the service."
  value       = data.aws_service_discovery_service.this.name
}

output "namespace_id" {
  description = "ID of the namespace that the service belongs to."
  value       = data.aws_service_discovery_service.this.namespace_id
}