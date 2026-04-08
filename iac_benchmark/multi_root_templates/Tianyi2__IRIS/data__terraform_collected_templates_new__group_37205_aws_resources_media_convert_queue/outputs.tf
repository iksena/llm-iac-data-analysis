output "id" {
  description = "The same as name"
  value       = aws_media_convert_queue.this.id
}

output "arn" {
  description = "The Arn of the queue"
  value       = aws_media_convert_queue.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_media_convert_queue.this.tags_all
}