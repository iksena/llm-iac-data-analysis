output "application_tag" {
  description = "A map with a single tag key-value pair used to associate resources with the application."
  value       = data.aws_servicecatalogappregistry_application.this.application_tag
}

output "arn" {
  description = "ARN (Amazon Resource Name) of the application."
  value       = data.aws_servicecatalogappregistry_application.this.arn
}

output "description" {
  description = "Description of the application."
  value       = data.aws_servicecatalogappregistry_application.this.description
}

output "id" {
  description = "Application identifier."
  value       = data.aws_servicecatalogappregistry_application.this.id
}

output "name" {
  description = "Name of the application."
  value       = data.aws_servicecatalogappregistry_application.this.name
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_servicecatalogappregistry_application.this.region
}

output "tags" {
  description = "A map of tags assigned to the Application."
  value       = data.aws_servicecatalogappregistry_application.this.tags
}