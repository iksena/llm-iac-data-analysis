output "id" {
  description = "The ID of a namespace."
  value       = aws_service_discovery_public_dns_namespace.this.id
}

output "arn" {
  description = "The ARN that Amazon Route 53 assigns to the namespace when you create it."
  value       = aws_service_discovery_public_dns_namespace.this.arn
}

output "hosted_zone" {
  description = "The ID for the hosted zone that Amazon Route 53 creates when you create a namespace."
  value       = aws_service_discovery_public_dns_namespace.this.hosted_zone
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_service_discovery_public_dns_namespace.this.tags_all
}