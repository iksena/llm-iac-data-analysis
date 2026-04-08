output "arn" {
  value       = data.aws_service_discovery_dns_namespace.this.arn
  description = "ARN of the namespace."
}

output "description" {
  value       = data.aws_service_discovery_dns_namespace.this.description
  description = "Description of the namespace."
}

output "id" {
  value       = data.aws_service_discovery_dns_namespace.this.id
  description = "Namespace ID."
}

output "hosted_zone" {
  value       = data.aws_service_discovery_dns_namespace.this.hosted_zone
  description = "ID for the hosted zone that Amazon Route 53 creates when you create a namespace."
}

output "tags" {
  value       = data.aws_service_discovery_dns_namespace.this.tags
  description = "Map of tags for the resource."
}

output "name" {
  value       = data.aws_service_discovery_dns_namespace.this.name
  description = "Name of the namespace."
}

output "type" {
  value       = data.aws_service_discovery_dns_namespace.this.type
  description = "Type of the namespace."
}

output "region" {
  value       = data.aws_service_discovery_dns_namespace.this.region
  description = "Region where this resource is managed."
}