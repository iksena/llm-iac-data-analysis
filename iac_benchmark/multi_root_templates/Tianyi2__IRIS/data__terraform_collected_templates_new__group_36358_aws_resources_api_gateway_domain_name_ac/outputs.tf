output "arn" {
  description = "ARN of the domain name access association."
  value       = aws_api_gateway_domain_name_access_association.this.arn
}

output "id" {
  description = "Internal identifier assigned to this domain name access association. (Deprecated, use arn instead)"
  value       = aws_api_gateway_domain_name_access_association.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_api_gateway_domain_name_access_association.this.tags_all
}