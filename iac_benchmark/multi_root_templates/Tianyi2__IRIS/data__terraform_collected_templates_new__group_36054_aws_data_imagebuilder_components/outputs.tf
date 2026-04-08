output "arns" {
  description = "Set of ARNs of the matched Image Builder Components."
  value       = data.aws_imagebuilder_components.this.arns
}

output "names" {
  description = "Set of names of the matched Image Builder Components."
  value       = data.aws_imagebuilder_components.this.names
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_imagebuilder_components.this.region
}

output "owner" {
  description = "Owner of the image recipes."
  value       = data.aws_imagebuilder_components.this.owner
}