output "id" {
  description = "The SQS queue URL"
  value       = aws_sqs_queue_redrive_policy.this.id
}

output "queue_url" {
  description = "The URL of the SQS Queue"
  value       = aws_sqs_queue_redrive_policy.this.queue_url
}

output "redrive_policy" {
  description = "The JSON redrive policy for the SQS queue"
  value       = aws_sqs_queue_redrive_policy.this.redrive_policy
}