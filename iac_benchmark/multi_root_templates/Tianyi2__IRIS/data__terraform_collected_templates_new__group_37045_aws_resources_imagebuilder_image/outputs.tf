output "arn" {
  description = "Amazon Resource Name (ARN) of the image."
  value       = aws_imagebuilder_image.this.arn
}

output "date_created" {
  description = "Date the image was created."
  value       = aws_imagebuilder_image.this.date_created
}

output "platform" {
  description = "Platform of the image."
  value       = aws_imagebuilder_image.this.platform
}

output "os_version" {
  description = "Operating System version of the image."
  value       = aws_imagebuilder_image.this.os_version
}

output "output_resources" {
  description = "List of objects with resources created by the image."
  value       = aws_imagebuilder_image.this.output_resources
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_imagebuilder_image.this.tags_all
}

output "version" {
  description = "Version of the image."
  value       = aws_imagebuilder_image.this.version
}