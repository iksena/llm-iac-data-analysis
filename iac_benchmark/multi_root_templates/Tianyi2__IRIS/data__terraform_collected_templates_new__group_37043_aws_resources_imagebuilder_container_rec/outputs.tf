output "arn" {
  description = "Amazon Resource Name (ARN) of the container recipe."
  value       = aws_imagebuilder_container_recipe.this.arn
}

output "date_created" {
  description = "Date the container recipe was created."
  value       = aws_imagebuilder_container_recipe.this.date_created
}

output "encrypted" {
  description = "A flag that indicates if the target container is encrypted."
  value       = aws_imagebuilder_container_recipe.this.encrypted
}

output "owner" {
  description = "Owner of the container recipe."
  value       = aws_imagebuilder_container_recipe.this.owner
}

output "platform" {
  description = "Platform of the container recipe."
  value       = aws_imagebuilder_container_recipe.this.platform
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_imagebuilder_container_recipe.this.tags_all
}