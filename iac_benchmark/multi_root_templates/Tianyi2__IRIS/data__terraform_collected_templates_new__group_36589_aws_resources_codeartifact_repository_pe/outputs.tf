output "id" {
  description = "The ARN of the resource associated with the resource policy."
  value       = aws_codeartifact_repository_permissions_policy.this.id
}

output "resource_arn" {
  description = "The ARN of the resource associated with the resource policy."
  value       = aws_codeartifact_repository_permissions_policy.this.resource_arn
}