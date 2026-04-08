output "arn" {
  description = "ARN of the image pipeline"
  value       = data.aws_imagebuilder_image_pipeline.this.arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_imagebuilder_image_pipeline.this.region
}

output "container_recipe_arn" {
  description = "ARN of the container recipe"
  value       = data.aws_imagebuilder_image_pipeline.this.container_recipe_arn
}

output "date_created" {
  description = "Date the image pipeline was created"
  value       = data.aws_imagebuilder_image_pipeline.this.date_created
}

output "date_last_run" {
  description = "Date the image pipeline was last run"
  value       = data.aws_imagebuilder_image_pipeline.this.date_last_run
}

output "date_next_run" {
  description = "Date the image pipeline will run next"
  value       = data.aws_imagebuilder_image_pipeline.this.date_next_run
}

output "date_updated" {
  description = "Date the image pipeline was updated"
  value       = data.aws_imagebuilder_image_pipeline.this.date_updated
}

output "description" {
  description = "Description of the image pipeline"
  value       = data.aws_imagebuilder_image_pipeline.this.description
}

output "distribution_configuration_arn" {
  description = "ARN of the Image Builder Distribution Configuration"
  value       = data.aws_imagebuilder_image_pipeline.this.distribution_configuration_arn
}

output "enhanced_image_metadata_enabled" {
  description = "Whether additional information about the image being created is collected"
  value       = data.aws_imagebuilder_image_pipeline.this.enhanced_image_metadata_enabled
}

output "image_recipe_arn" {
  description = "ARN of the image recipe"
  value       = data.aws_imagebuilder_image_pipeline.this.image_recipe_arn
}

output "image_scanning_configuration" {
  description = "List of an object with image scanning configuration"
  value       = data.aws_imagebuilder_image_pipeline.this.image_scanning_configuration
}

output "image_tests_configuration" {
  description = "List of an object with image tests configuration"
  value       = data.aws_imagebuilder_image_pipeline.this.image_tests_configuration
}

output "infrastructure_configuration_arn" {
  description = "ARN of the Image Builder Infrastructure Configuration"
  value       = data.aws_imagebuilder_image_pipeline.this.infrastructure_configuration_arn
}

output "name" {
  description = "Name of the image pipeline"
  value       = data.aws_imagebuilder_image_pipeline.this.name
}

output "platform" {
  description = "Platform of the image pipeline"
  value       = data.aws_imagebuilder_image_pipeline.this.platform
}

output "schedule" {
  description = "List of an object with schedule settings"
  value       = data.aws_imagebuilder_image_pipeline.this.schedule
}

output "status" {
  description = "Status of the image pipeline"
  value       = data.aws_imagebuilder_image_pipeline.this.status
}

output "tags" {
  description = "Key-value map of resource tags for the image pipeline"
  value       = data.aws_imagebuilder_image_pipeline.this.tags
}