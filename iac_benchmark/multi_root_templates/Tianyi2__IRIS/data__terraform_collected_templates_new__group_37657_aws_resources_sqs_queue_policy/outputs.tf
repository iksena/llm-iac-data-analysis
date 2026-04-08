output "id" {
  description = "The SQS queue policy ID (queue URL)"
  value       = aws_sqs_queue_policy.this.id
}

output "region" {
  description = "The region where the SQS queue policy is managed"
  value       = aws_sqs_queue_policy.this.region
}

output "policy" {
  description = "The JSON policy applied to the SQS queue"
  value       = aws_sqs_queue_policy.this.policy
}

output "queue_url" {
  description = "The URL of the SQS Queue to which the policy is attached"
  value       = aws_sqs_queue_policy.this.queue_url
}