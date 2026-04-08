output "application_tag" {
  description = "A map with a single tag key-value pair used to associate resources with the application. This attribute can be passed directly into the tags argument of another resource, or merged into a map of existing tags."
  value       = aws_servicecatalogappregistry_application.this.application_tag
}

output "arn" {
  description = "ARN (Amazon Resource Name) of the application."
  value       = aws_servicecatalogappregistry_application.this.arn
}

output "id" {
  description = "Identifier of the application."
  value       = aws_servicecatalogappregistry_application.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_servicecatalogappregistry_application.this.tags_all
}