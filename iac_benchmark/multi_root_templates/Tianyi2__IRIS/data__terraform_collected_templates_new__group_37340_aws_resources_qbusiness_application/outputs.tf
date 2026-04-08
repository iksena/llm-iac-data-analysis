output "application_id" {
  description = "ID of the Q Business application"
  value       = aws_qbusiness_application.this.id
}

output "arn" {
  description = "ARN of the Q Business application"
  value       = aws_qbusiness_application.this.arn
}

output "identity_center_application_arn" {
  description = "ARN of the AWS IAM Identity Center application attached to your Amazon Q Business application"
  value       = aws_qbusiness_application.this.identity_center_application_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_qbusiness_application.this.tags_all
}