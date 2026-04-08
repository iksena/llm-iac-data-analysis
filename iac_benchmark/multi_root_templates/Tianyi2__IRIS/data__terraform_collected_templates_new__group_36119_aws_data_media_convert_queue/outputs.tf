output "arn" {
  description = "The Arn of the queue."
  value       = data.aws_media_convert_queue.this.arn
}

output "name" {
  description = "The same as id."
  value       = data.aws_media_convert_queue.this.name
}

output "status" {
  description = "The status of the queue."
  value       = data.aws_media_convert_queue.this.status
}

output "tags" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = data.aws_media_convert_queue.this.tags
}

output "id" {
  description = "Unique identifier of the queue. The same as name."
  value       = data.aws_media_convert_queue.this.id
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_media_convert_queue.this.region
}