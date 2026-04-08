output "groups" {
  description = "List of Identity Store Groups"
  value       = data.aws_identitystore_groups.this.groups
}

output "group_ids" {
  description = "List of group identifiers in the Identity Store"
  value       = [for group in data.aws_identitystore_groups.this.groups : group.group_id]
}

output "group_display_names" {
  description = "List of group display names"
  value       = [for group in data.aws_identitystore_groups.this.groups : group.display_name]
}

output "group_descriptions" {
  description = "List of group descriptions"
  value       = [for group in data.aws_identitystore_groups.this.groups : group.description]
}

output "groups_with_external_ids" {
  description = "Groups that have external identifiers"
  value       = [for group in data.aws_identitystore_groups.this.groups : group if length(group.external_ids) > 0]
}