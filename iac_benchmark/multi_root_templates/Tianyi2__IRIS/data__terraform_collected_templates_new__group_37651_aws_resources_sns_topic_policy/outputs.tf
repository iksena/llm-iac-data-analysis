output "arn" {
  description = "The ARN of the SNS topic"
  value       = aws_sns_topic_policy.this.arn
}

output "owner" {
  description = "The AWS Account ID of the SNS topic owner"
  value       = aws_sns_topic_policy.this.owner
}

output "policy" {
  description = "The fully-formed AWS policy as JSON"
  value       = aws_sns_topic_policy.this.policy
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_sns_topic_policy.this.region
}