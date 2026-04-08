output "arns" {
  description = "Set of ARNs of the matched Image Builder Image Recipes."
  value       = data.aws_imagebuilder_image_recipes.this.arns
}

output "names" {
  description = "Set of names of the matched Image Builder Image Recipes."
  value       = data.aws_imagebuilder_image_recipes.this.names
}