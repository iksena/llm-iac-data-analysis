output "arn" {
  description = "ARN of the SQS queue."
  value       = aws_sqs_queue.this.arn
}

output "id" {
  description = "URL for the created Amazon SQS queue."
  value       = aws_sqs_queue.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_sqs_queue.this.tags_all
}

output "url" {
  description = "Same as id: The URL for the created Amazon SQS queue."
  value       = aws_sqs_queue.this.url
}