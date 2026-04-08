output "region" {
  description = "The AWS region this module resources resides in."
  value       = local.user.region
}

output "id" {
  description = "The ID of the QuickSight user."
  value       = local.user.id
}

output "arn" {
  description = "The ARN of the QuickSight user."
  value       = local.user.arn
}

output "principal_id" {
  description = "The principal ID of the user."
  value       = try(local.user.principal_id, null)
}

output "is_active" {
  description = "Whether the user is active or not."
  value       = try(local.user.active, null)
}

output "name" {
  description = "The name of the QuickSight user."
  value       = local.user.user_name
}

output "type" {
  description = "The type of the QuickSight user."
  value       = var.type
}

output "identity_type" {
  description = "The identity type for the user."
  value       = local.user.identity_type
}

output "namespace" {
  description = "The namespace that the user belongs to."
  value       = local.user.namespace
}

output "email" {
  description = "The email address of the user."
  value       = local.user.email
}

output "role" {
  description = "The Amazon QuickSight role for the user."
  value       = local.user.user_role
}

# output "debug" {
#   value = {
#     for k, v in local.user :
#     k => v
#     if !contains(["id", "arn", "user_name", "namespace", "email", "user_role", "identity_type", "principal_id", "aws_account_id", "active", "region"], k)
#   }
# }
