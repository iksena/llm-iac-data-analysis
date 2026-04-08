output "id" {
  value       = aws_service_discovery_private_dns_namespace.this.id
  description = "The ID of a namespace."
}

output "arn" {
  value       = aws_service_discovery_private_dns_namespace.this.arn
  description = "The ARN that Amazon Route 53 assigns to the namespace when you create it."
}

output "hosted_zone" {
  value       = aws_service_discovery_private_dns_namespace.this.hosted_zone
  description = "The ID for the hosted zone that Amazon Route 53 creates when you create a namespace."
}

output "tags_all" {
  value       = aws_service_discovery_private_dns_namespace.this.tags_all
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}