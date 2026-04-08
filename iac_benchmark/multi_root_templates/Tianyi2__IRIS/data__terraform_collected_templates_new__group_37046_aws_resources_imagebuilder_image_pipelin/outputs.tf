output "arn" {
  description = "Amazon Resource Name (ARN) of the image pipeline"
  value       = aws_imagebuilder_image_pipeline.this.arn
}

output "date_created" {
  description = "Date the image pipeline was created"
  value       = aws_imagebuilder_image_pipeline.this.date_created
}

output "date_last_run" {
  description = "Date the image pipeline was last run"
  value       = aws_imagebuilder_image_pipeline.this.date_last_run
}

output "date_next_run" {
  description = "Date the image pipeline will run next"
  value       = aws_imagebuilder_image_pipeline.this.date_next_run
}

output "date_updated" {
  description = "Date the image pipeline was updated"
  value       = aws_imagebuilder_image_pipeline.this.date_updated
}

output "platform" {
  description = "Platform of the image pipeline"
  value       = aws_imagebuilder_image_pipeline.this.platform
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_imagebuilder_image_pipeline.this.tags_all
}