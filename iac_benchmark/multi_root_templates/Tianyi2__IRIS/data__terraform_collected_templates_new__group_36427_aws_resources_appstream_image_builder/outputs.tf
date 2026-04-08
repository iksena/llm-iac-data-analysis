output "arn" {
  description = "ARN of the appstream image builder."
  value       = aws_appstream_image_builder.this.arn
}

output "created_time" {
  description = "Date and time, in UTC and extended RFC 3339 format, when the image builder was created."
  value       = aws_appstream_image_builder.this.created_time
}

output "id" {
  description = "Name of the image builder."
  value       = aws_appstream_image_builder.this.id
}

output "state" {
  description = "State of the image builder."
  value       = aws_appstream_image_builder.this.state
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appstream_image_builder.this.tags_all
}