output "id" {
  description = "The Amazon Resource Names (ARNs) of the Permission Set and SSO Instance, separated by a comma."
  value       = aws_ssoadmin_permission_set_inline_policy.this.id
}