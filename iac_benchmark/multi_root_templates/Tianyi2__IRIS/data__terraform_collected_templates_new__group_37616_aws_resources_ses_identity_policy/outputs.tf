output "id" {
  description = "The ID of the SES Identity Policy."
  value       = aws_ses_identity_policy.this.id
}

output "identity" {
  description = "Name or Amazon Resource Name (ARN) of the SES Identity."
  value       = aws_ses_identity_policy.this.identity
}

output "name" {
  description = "Name of the policy."
  value       = aws_ses_identity_policy.this.name
}

output "policy" {
  description = "JSON string of the policy."
  value       = aws_ses_identity_policy.this.policy
}