output "id" {
  description = "The name of the source repository."
  value       = aws_codecatalyst_source_repository.this.id
}

output "name" {
  description = "The name of the source repository."
  value       = aws_codecatalyst_source_repository.this.name
}

output "space_name" {
  description = "The name of the CodeCatalyst space."
  value       = aws_codecatalyst_source_repository.this.space_name
}

output "project_name" {
  description = "The name of the project in the CodeCatalyst space."
  value       = aws_codecatalyst_source_repository.this.project_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_codecatalyst_source_repository.this.region
}

output "description" {
  description = "The description of the project."
  value       = aws_codecatalyst_source_repository.this.description
}