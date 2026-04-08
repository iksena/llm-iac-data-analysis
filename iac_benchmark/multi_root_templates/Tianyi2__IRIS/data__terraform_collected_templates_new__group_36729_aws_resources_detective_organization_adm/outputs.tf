output "id" {
  description = "AWS account identifier"
  value       = aws_detective_organization_admin_account.this.id
}

output "account_id" {
  description = "AWS account identifier to designate as a delegated administrator for Detective"
  value       = aws_detective_organization_admin_account.this.account_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_detective_organization_admin_account.this.region
}