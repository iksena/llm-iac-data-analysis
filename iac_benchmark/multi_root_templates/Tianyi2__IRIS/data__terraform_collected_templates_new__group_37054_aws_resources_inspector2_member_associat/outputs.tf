output "delegated_admin_account_id" {
  description = "Account ID of the delegated administrator account"
  value       = aws_inspector2_member_association.this.delegated_admin_account_id
}

output "relationship_status" {
  description = "Status of the member relationship"
  value       = aws_inspector2_member_association.this.relationship_status
}

output "updated_at" {
  description = "Date and time of the last update of the relationship"
  value       = aws_inspector2_member_association.this.updated_at
}

output "account_id" {
  description = "ID of the account to associate"
  value       = aws_inspector2_member_association.this.account_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_inspector2_member_association.this.region
}