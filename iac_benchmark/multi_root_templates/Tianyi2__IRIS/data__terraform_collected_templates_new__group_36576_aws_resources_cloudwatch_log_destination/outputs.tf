output "region" {
  description = "The region where the CloudWatch log destination policy is managed"
  value       = aws_cloudwatch_log_destination_policy.this.region
}

output "destination_name" {
  description = "The name of the subscription filter"
  value       = aws_cloudwatch_log_destination_policy.this.destination_name
}

output "access_policy" {
  description = "The policy document"
  value       = aws_cloudwatch_log_destination_policy.this.access_policy
}

output "force_update" {
  description = "Whether force update is enabled for organization ID permissions"
  value       = aws_cloudwatch_log_destination_policy.this.force_update
}