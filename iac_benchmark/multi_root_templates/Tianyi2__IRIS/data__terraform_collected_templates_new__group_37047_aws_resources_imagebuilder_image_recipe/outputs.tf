output "arn" {
  description = "Amazon Resource Name (ARN) of the image recipe"
  value       = aws_imagebuilder_image_recipe.this.arn
}

output "date_created" {
  description = "Date the image recipe was created"
  value       = aws_imagebuilder_image_recipe.this.date_created
}

output "owner" {
  description = "Owner of the image recipe"
  value       = aws_imagebuilder_image_recipe.this.owner
}

output "platform" {
  description = "Platform of the image recipe"
  value       = aws_imagebuilder_image_recipe.this.platform
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_imagebuilder_image_recipe.this.tags_all
}