output "id" {
  description = "The ID of the environment membership."
  value       = aws_cloud9_environment_membership.this.id
}

output "user_id" {
  description = "The user ID in AWS Identity and Access Management (AWS IAM) of the environment member."
  value       = aws_cloud9_environment_membership.this.user_id
}