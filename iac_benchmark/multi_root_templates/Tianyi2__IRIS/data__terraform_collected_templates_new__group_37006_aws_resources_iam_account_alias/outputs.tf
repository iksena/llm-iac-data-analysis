output "account_alias" {
  description = "The account alias"
  value       = aws_iam_account_alias.this.account_alias
}

output "id" {
  description = "The account alias (same as account_alias)"
  value       = aws_iam_account_alias.this.id
}