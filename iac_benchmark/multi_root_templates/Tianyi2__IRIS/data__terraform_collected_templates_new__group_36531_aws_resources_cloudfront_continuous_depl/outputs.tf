output "arn" {
  description = "The continuous deployment policy ARN"
  value       = aws_cloudfront_continuous_deployment_policy.this.arn
}

output "etag" {
  description = "Current version of the continuous distribution policy"
  value       = aws_cloudfront_continuous_deployment_policy.this.etag
}

output "id" {
  description = "Identifier of the continuous deployment policy"
  value       = aws_cloudfront_continuous_deployment_policy.this.id
}

output "last_modified_time" {
  description = "Date and time the continuous deployment policy was last modified"
  value       = aws_cloudfront_continuous_deployment_policy.this.last_modified_time
}