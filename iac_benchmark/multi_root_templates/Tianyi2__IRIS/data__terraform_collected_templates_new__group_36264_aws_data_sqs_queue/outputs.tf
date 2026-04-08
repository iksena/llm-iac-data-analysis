output "arn" {
  description = "ARN of the queue"
  value       = data.aws_sqs_queue.this.arn
}

output "url" {
  description = "URL of the queue"
  value       = data.aws_sqs_queue.this.url
}

output "tags" {
  description = "Map of tags for the resource"
  value       = data.aws_sqs_queue.this.tags
}