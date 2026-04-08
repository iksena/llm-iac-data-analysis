output "region" {
  description = "The AWS region this module resources resides in."
  value       = local.group.region
}

output "id" {
  description = "The ID of the QuickSight group."
  value       = local.group.id
}

output "arn" {
  description = "The ARN of the QuickSight group."
  value       = local.group.arn
}

output "principal_id" {
  description = "The principal ID of the group."
  value       = try(local.group.principal_id, null)
}

output "name" {
  description = "The name of the QuickSight group."
  value       = local.group.group_name
}

output "type" {
  description = "The type of the QuickSight group."
  value       = var.type
}

output "description" {
  description = "The description of the QuickSight group."
  value       = local.group.description
}

output "namespace" {
  description = "The namespace that the group belongs to."
  value       = local.group.namespace
}

output "members" {
  description = "A set of user names that you want to add to the group membership."
  value       = keys(aws_quicksight_group_membership.this)
}

output "role" {
  description = "The QuickSight role assigned to the group."
  value       = var.role
}
