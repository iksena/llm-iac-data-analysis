output "arn" {
  description = "The Amazon Resource Name (ARN) of the Queue."
  value       = aws_connect_queue.this.arn
}

output "queue_id" {
  description = "The identifier for the Queue."
  value       = aws_connect_queue.this.queue_id
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance and identifier of the Queue separated by a colon (:)."
  value       = aws_connect_queue.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_connect_queue.this.tags_all
}