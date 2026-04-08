output "id" {
  description = "ID of a namespace."
  value       = data.aws_service_discovery_http_namespace.this.id
}

output "arn" {
  description = "ARN that Amazon Route 53 assigns to the namespace when you create it."
  value       = data.aws_service_discovery_http_namespace.this.arn
}

output "description" {
  description = "Description that you specify for the namespace when you create it."
  value       = data.aws_service_discovery_http_namespace.this.description
}

output "http_name" {
  description = "Name of an HTTP namespace."
  value       = data.aws_service_discovery_http_namespace.this.http_name
}

output "tags" {
  description = "Map of tags for the resource."
  value       = data.aws_service_discovery_http_namespace.this.tags
}