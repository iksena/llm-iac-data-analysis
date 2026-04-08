output "arn" {
  description = "ARN of the image"
  value       = data.aws_imagebuilder_image.this.arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_imagebuilder_image.this.region
}

output "build_version_arn" {
  description = "Build version ARN of the image. This will always have the #.#.#/# suffix"
  value       = data.aws_imagebuilder_image.this.build_version_arn
}

output "container_recipe_arn" {
  description = "ARN of the container recipe"
  value       = data.aws_imagebuilder_image.this.container_recipe_arn
}

output "date_created" {
  description = "Date the image was created"
  value       = data.aws_imagebuilder_image.this.date_created
}

output "distribution_configuration_arn" {
  description = "ARN of the Image Builder Distribution Configuration"
  value       = data.aws_imagebuilder_image.this.distribution_configuration_arn
}

output "enhanced_image_metadata_enabled" {
  description = "Whether additional information about the image being created is collected"
  value       = data.aws_imagebuilder_image.this.enhanced_image_metadata_enabled
}

output "image_recipe_arn" {
  description = "ARN of the image recipe"
  value       = data.aws_imagebuilder_image.this.image_recipe_arn
}

output "image_scanning_configuration" {
  description = "List of an object with image scanning configuration fields"
  value       = data.aws_imagebuilder_image.this.image_scanning_configuration
}

output "image_tests_configuration" {
  description = "List of an object with image tests configuration"
  value       = data.aws_imagebuilder_image.this.image_tests_configuration
}

output "infrastructure_configuration_arn" {
  description = "ARN of the Image Builder Infrastructure Configuration"
  value       = data.aws_imagebuilder_image.this.infrastructure_configuration_arn
}

output "name" {
  description = "Name of the image"
  value       = data.aws_imagebuilder_image.this.name
}

output "platform" {
  description = "Platform of the image"
  value       = data.aws_imagebuilder_image.this.platform
}

output "os_version" {
  description = "Operating System version of the image"
  value       = data.aws_imagebuilder_image.this.os_version
}

output "output_resources" {
  description = "List of objects with resources created by the image"
  value       = data.aws_imagebuilder_image.this.output_resources
}

output "tags" {
  description = "Key-value map of resource tags for the image"
  value       = data.aws_imagebuilder_image.this.tags
}

output "version" {
  description = "Version of the image"
  value       = data.aws_imagebuilder_image.this.version
}