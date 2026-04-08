output "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the DynamoDB resource to which the policy will be attached."
  value       = aws_dynamodb_resource_policy.this.resource_arn
}

output "policy" {
  description = "An Amazon Web Services resource-based policy document in JSON format."
  value       = aws_dynamodb_resource_policy.this.policy
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_dynamodb_resource_policy.this.region
}

output "confirm_remove_self_resource_access" {
  description = "Parameter to confirm removal of permissions to change the policy of this resource in the future."
  value       = aws_dynamodb_resource_policy.this.confirm_remove_self_resource_access
}

output "revision_id" {
  description = "A unique string that represents the revision ID of the policy. If you are comparing revision IDs, make sure to always use string comparison logic."
  value       = aws_dynamodb_resource_policy.this.revision_id
}