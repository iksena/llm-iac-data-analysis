output "id" {
  description = "AWS account identifier"
  value       = aws_securityhub_organization_admin_account.this.id
}