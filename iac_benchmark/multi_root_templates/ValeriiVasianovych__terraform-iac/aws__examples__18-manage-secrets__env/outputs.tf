output "region" {
  value = data.aws_region.current.name
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "db_username" {
  value = var.db_username
  sensitive = false
}

output "db_password" {
  value     = var.db_password
  sensitive = false
}
