output "arn" {
  description = "ARN of the image recipe"
  value       = data.aws_imagebuilder_image_recipe.this.arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_imagebuilder_image_recipe.this.region
}

output "block_device_mapping" {
  description = "Set of objects with block device mappings for the image recipe"
  value       = data.aws_imagebuilder_image_recipe.this.block_device_mapping
}

output "component" {
  description = "List of objects with components for the image recipe"
  value       = data.aws_imagebuilder_image_recipe.this.component
}

output "date_created" {
  description = "Date the image recipe was created"
  value       = data.aws_imagebuilder_image_recipe.this.date_created
}

output "description" {
  description = "Description of the image recipe"
  value       = data.aws_imagebuilder_image_recipe.this.description
}

output "name" {
  description = "Name of the image recipe"
  value       = data.aws_imagebuilder_image_recipe.this.name
}

output "owner" {
  description = "Owner of the image recipe"
  value       = data.aws_imagebuilder_image_recipe.this.owner
}

output "parent_image" {
  description = "Base image of the image recipe"
  value       = data.aws_imagebuilder_image_recipe.this.parent_image
}

output "platform" {
  description = "Platform of the image recipe"
  value       = data.aws_imagebuilder_image_recipe.this.platform
}

output "tags" {
  description = "Key-value map of resource tags for the image recipe"
  value       = data.aws_imagebuilder_image_recipe.this.tags
}

output "user_data_base64" {
  description = "Base64 encoded contents of user data. Commands or a command script to run when build instance is launched"
  value       = data.aws_imagebuilder_image_recipe.this.user_data_base64
}

output "version" {
  description = "Version of the image recipe"
  value       = data.aws_imagebuilder_image_recipe.this.version
}

output "working_directory" {
  description = "Working directory used during build and test workflows"
  value       = data.aws_imagebuilder_image_recipe.this.working_directory
}