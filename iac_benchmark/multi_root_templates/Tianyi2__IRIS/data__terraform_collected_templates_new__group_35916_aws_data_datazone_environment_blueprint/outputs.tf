output "id" {
  description = "ID of the environment blueprint"
  value       = data.aws_datazone_environment_blueprint.this.id
}

output "description" {
  description = "Description of the blueprint"
  value       = data.aws_datazone_environment_blueprint.this.description
}

output "blueprint_provider" {
  description = "Provider of the blueprint"
  value       = data.aws_datazone_environment_blueprint.this.blueprint_provider
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_datazone_environment_blueprint.this.region
}

output "domain_id" {
  description = "ID of the domain"
  value       = data.aws_datazone_environment_blueprint.this.domain_id
}

output "name" {
  description = "Name of the blueprint"
  value       = data.aws_datazone_environment_blueprint.this.name
}

output "managed" {
  description = "Whether the blueprint is managed by Amazon DataZone"
  value       = data.aws_datazone_environment_blueprint.this.managed
}