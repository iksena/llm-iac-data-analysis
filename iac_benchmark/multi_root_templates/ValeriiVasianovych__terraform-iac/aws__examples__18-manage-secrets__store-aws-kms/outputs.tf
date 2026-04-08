output "region" {
  value = data.aws_region.current.name
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "db_creds_username" {
  value = local.db_creds.username
  sensitive = true
}

output "db_creds_password" {
  value = local.db_creds.password
  sensitive = true
}