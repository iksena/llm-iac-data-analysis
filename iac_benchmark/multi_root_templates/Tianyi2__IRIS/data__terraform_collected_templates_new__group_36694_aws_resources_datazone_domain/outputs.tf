output "arn" {
  description = "ARN of the Domain."
  value       = aws_datazone_domain.this.arn
}

output "id" {
  description = "ID of the Domain."
  value       = aws_datazone_domain.this.id
}

output "portal_url" {
  description = "URL of the data portal for the Domain."
  value       = aws_datazone_domain.this.portal_url
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_datazone_domain.this.tags_all
}