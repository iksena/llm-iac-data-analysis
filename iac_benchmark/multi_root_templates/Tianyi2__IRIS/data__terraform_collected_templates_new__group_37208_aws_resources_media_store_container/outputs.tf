output "arn" {
  description = "The ARN of the container."
  value       = aws_media_store_container.this.arn
}

output "endpoint" {
  description = "The DNS endpoint of the container."
  value       = aws_media_store_container.this.endpoint
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_media_store_container.this.tags_all
}