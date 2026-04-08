output "admin_account_id" {
  description = "AWS account identifier designated as a delegated administrator for GuardDuty"
  value       = aws_guardduty_organization_admin_account.this.admin_account_id
}

output "region" {
  description = "Region where the resource is managed"
  value       = aws_guardduty_organization_admin_account.this.region
}