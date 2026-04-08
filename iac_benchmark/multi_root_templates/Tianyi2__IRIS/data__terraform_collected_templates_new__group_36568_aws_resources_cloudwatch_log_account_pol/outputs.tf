output "id" {
  description = "The ID of the CloudWatch Log Account Policy resource."
  value       = aws_cloudwatch_log_account_policy.this.id
}

output "policy_name" {
  description = "The name of the account policy."
  value       = aws_cloudwatch_log_account_policy.this.policy_name
}

output "policy_type" {
  description = "The type of account policy."
  value       = aws_cloudwatch_log_account_policy.this.policy_type
}

output "policy_document" {
  description = "The text of the account policy."
  value       = aws_cloudwatch_log_account_policy.this.policy_document
}

output "region" {
  description = "The region where this resource is managed."
  value       = aws_cloudwatch_log_account_policy.this.region
}

output "scope" {
  description = "The scope of the account policy."
  value       = aws_cloudwatch_log_account_policy.this.scope
}

output "selection_criteria" {
  description = "The criteria for applying a subscription filter policy to a selection of log groups."
  value       = aws_cloudwatch_log_account_policy.this.selection_criteria
}