output "applications" {
  description = "A list of application objects that contain application details"
  value       = data.aws_appstream_image.this.applications
}

output "appstream_agent_version" {
  description = "Version of the AppStream 2.0 agent to use for instances that are launched from this image"
  value       = data.aws_appstream_image.this.appstream_agent_version
}

output "arn" {
  description = "ARN of the image"
  value       = data.aws_appstream_image.this.arn
}

output "base_image_arn" {
  description = "ARN of the image from which the image was created"
  value       = data.aws_appstream_image.this.base_image_arn
}

output "created_time" {
  description = "Time at which this image was created"
  value       = data.aws_appstream_image.this.created_time
}

output "description" {
  description = "Description of image"
  value       = data.aws_appstream_image.this.description
}

output "display_name" {
  description = "Image name to display"
  value       = data.aws_appstream_image.this.display_name
}

output "image_builder_name" {
  description = "The name of the image builder that was used to created the private image"
  value       = data.aws_appstream_image.this.image_builder_name
}

output "image_builder_supported" {
  description = "Boolean to indicate whether an image builder can be launched from this image"
  value       = data.aws_appstream_image.this.image_builder_supported
}

output "image_permissions" {
  description = "List of objects describing the image permissions"
  value       = data.aws_appstream_image.this.image_permissions
}

output "name" {
  description = "Name of the image"
  value       = data.aws_appstream_image.this.name
}

output "platform" {
  description = "Operating system platform of the image"
  value       = data.aws_appstream_image.this.platform
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_appstream_image.this.region
}

output "state" {
  description = "Current state of image"
  value       = data.aws_appstream_image.this.state
}

output "type" {
  description = "The type of image"
  value       = data.aws_appstream_image.this.type
}


