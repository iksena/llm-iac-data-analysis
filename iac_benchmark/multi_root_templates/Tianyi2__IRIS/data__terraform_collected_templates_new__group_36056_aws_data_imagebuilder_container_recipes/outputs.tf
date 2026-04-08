output "arns" {
  description = "Set of ARNs of the matched Image Builder Container Recipes."
  value       = data.aws_imagebuilder_container_recipes.this.arns
}

output "names" {
  description = "Set of names of the matched Image Builder Container Recipes."
  value       = data.aws_imagebuilder_container_recipes.this.names
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_imagebuilder_container_recipes.this.region
}

output "owner" {
  description = "Owner of the container recipes."
  value       = data.aws_imagebuilder_container_recipes.this.owner
}