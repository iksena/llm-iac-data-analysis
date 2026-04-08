output "id" {
  description = "The SQS Queue URL"
  value       = aws_sqs_queue_redrive_allow_policy.this.id
}

output "queue_url" {
  description = "The URL of the SQS Queue to which the policy is attached"
  value       = aws_sqs_queue_redrive_allow_policy.this.queue_url
}