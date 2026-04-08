output "id" {
  description = "The ID of a namespace."
  value       = aws_service_discovery_http_namespace.this.id
}

output "arn" {
  description = "The ARN that Amazon Route 53 assigns to the namespace when you create it."
  value       = aws_service_discovery_http_namespace.this.arn
}

output "http_name" {
  description = "The name of an HTTP namespace."
  value       = aws_service_discovery_http_namespace.this.http_name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_service_discovery_http_namespace.this.tags_all
}