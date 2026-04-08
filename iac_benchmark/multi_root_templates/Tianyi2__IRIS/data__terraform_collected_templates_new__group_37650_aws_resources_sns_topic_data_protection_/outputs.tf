output "arn" {
  description = "The ARN of the SNS topic"
  value       = aws_sns_topic_data_protection_policy.this.arn
}

output "policy" {
  description = "The fully-formed AWS policy as JSON"
  value       = aws_sns_topic_data_protection_policy.this.policy
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_sns_topic_data_protection_policy.this.region
}