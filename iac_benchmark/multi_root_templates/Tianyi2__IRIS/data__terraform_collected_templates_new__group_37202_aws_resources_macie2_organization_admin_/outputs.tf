output "id" {
  description = "The unique identifier (ID) of the macie organization admin account"
  value       = aws_macie2_organization_admin_account.this.id
}

output "admin_account_id" {
  description = "The AWS account ID for the account designated as the delegated Amazon Macie administrator account"
  value       = aws_macie2_organization_admin_account.this.admin_account_id
}

output "region" {
  description = "The region where the resource is managed"
  value       = aws_macie2_organization_admin_account.this.region
}