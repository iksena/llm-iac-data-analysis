output "relationship_status" {
  description = "Status of this delegated admin account"
  value       = aws_inspector2_delegated_admin_account.this.relationship_status
}

output "account_id" {
  description = "Account ID of the delegated admin account"
  value       = aws_inspector2_delegated_admin_account.this.account_id
}

output "region" {
  description = "Region where the resource is managed"
  value       = aws_inspector2_delegated_admin_account.this.region
}