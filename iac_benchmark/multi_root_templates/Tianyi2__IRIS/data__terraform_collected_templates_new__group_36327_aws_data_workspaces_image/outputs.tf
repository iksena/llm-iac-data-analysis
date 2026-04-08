output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_workspaces_image.this.region
}

output "image_id" {
  description = "ID of the image."
  value       = data.aws_workspaces_image.this.image_id
}

output "name" {
  description = "The name of the image."
  value       = data.aws_workspaces_image.this.name
}

output "description" {
  description = "The description of the image."
  value       = data.aws_workspaces_image.this.description
}


output "required_tenancy" {
  description = "Specifies whether the image is running on dedicated hardware. When Bring Your Own License (BYOL) is enabled, this value is set to DEDICATED."
  value       = data.aws_workspaces_image.this.required_tenancy
}

output "state" {
  description = "The status of the image."
  value       = data.aws_workspaces_image.this.state
}