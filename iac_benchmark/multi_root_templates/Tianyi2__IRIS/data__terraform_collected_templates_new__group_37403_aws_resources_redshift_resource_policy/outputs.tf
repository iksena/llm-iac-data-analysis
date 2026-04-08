output "id" {
  description = "The Amazon Resource Name (ARN) of the account to create or update a resource policy for"
  value       = aws_redshift_resource_policy.this.id
}