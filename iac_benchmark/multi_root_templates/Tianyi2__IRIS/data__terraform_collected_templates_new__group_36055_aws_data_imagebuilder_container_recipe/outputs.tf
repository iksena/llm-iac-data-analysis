output "arn" {
  description = "ARN of the container recipe."
  value       = data.aws_imagebuilder_container_recipe.this.arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_imagebuilder_container_recipe.this.region
}

output "component" {
  description = "List of objects with components for the container recipe."
  value       = data.aws_imagebuilder_container_recipe.this.component
}

output "container_type" {
  description = "Type of the container."
  value       = data.aws_imagebuilder_container_recipe.this.container_type
}

output "date_created" {
  description = "Date the container recipe was created."
  value       = data.aws_imagebuilder_container_recipe.this.date_created
}

output "description" {
  description = "Description of the container recipe."
  value       = data.aws_imagebuilder_container_recipe.this.description
}

output "dockerfile_template_data" {
  description = "Dockerfile template used to build the image."
  value       = data.aws_imagebuilder_container_recipe.this.dockerfile_template_data
}

output "encrypted" {
  description = "Flag that indicates if the target container is encrypted."
  value       = data.aws_imagebuilder_container_recipe.this.encrypted
}

output "instance_configuration" {
  description = "List of objects with instance configurations for building and testing container images."
  value       = data.aws_imagebuilder_container_recipe.this.instance_configuration
}

output "kms_key_id" {
  description = "KMS key used to encrypt the container image."
  value       = data.aws_imagebuilder_container_recipe.this.kms_key_id
}

output "name" {
  description = "Name of the container recipe."
  value       = data.aws_imagebuilder_container_recipe.this.name
}

output "owner" {
  description = "Owner of the container recipe."
  value       = data.aws_imagebuilder_container_recipe.this.owner
}

output "parent_image" {
  description = "Base image for the container recipe."
  value       = data.aws_imagebuilder_container_recipe.this.parent_image
}

output "platform" {
  description = "Platform of the container recipe."
  value       = data.aws_imagebuilder_container_recipe.this.platform
}

output "tags" {
  description = "Key-value map of resource tags for the container recipe."
  value       = data.aws_imagebuilder_container_recipe.this.tags
}

output "target_repository" {
  description = "Destination repository for the container image."
  value       = data.aws_imagebuilder_container_recipe.this.target_repository
}

output "version" {
  description = "Version of the container recipe."
  value       = data.aws_imagebuilder_container_recipe.this.version
}

output "working_directory" {
  description = "Working directory used during build and test workflows."
  value       = data.aws_imagebuilder_container_recipe.this.working_directory
}