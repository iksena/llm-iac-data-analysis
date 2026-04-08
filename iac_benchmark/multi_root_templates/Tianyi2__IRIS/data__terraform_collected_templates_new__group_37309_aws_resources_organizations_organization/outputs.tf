output "accounts" {
  description = "List of organization accounts including the master account. For a list excluding the master account, see the `non_master_accounts` attribute."
  value       = aws_organizations_organization.this.accounts
}

output "arn" {
  description = "ARN of the organization"
  value       = aws_organizations_organization.this.arn
}

output "id" {
  description = "Identifier of the organization"
  value       = aws_organizations_organization.this.id
}

output "master_account_arn" {
  description = "ARN of the master account"
  value       = aws_organizations_organization.this.master_account_arn
}

output "master_account_email" {
  description = "Email address of the master account"
  value       = aws_organizations_organization.this.master_account_email
}

output "master_account_id" {
  description = "Identifier of the master account"
  value       = aws_organizations_organization.this.master_account_id
}

output "master_account_name" {
  description = "Name of the master account"
  value       = aws_organizations_organization.this.master_account_name
}

output "non_master_accounts" {
  description = "List of organization accounts excluding the master account. For a list including the master account, see the `accounts` attribute."
  value       = aws_organizations_organization.this.non_master_accounts
}

output "roots" {
  description = "List of organization roots."
  value       = aws_organizations_organization.this.roots
}