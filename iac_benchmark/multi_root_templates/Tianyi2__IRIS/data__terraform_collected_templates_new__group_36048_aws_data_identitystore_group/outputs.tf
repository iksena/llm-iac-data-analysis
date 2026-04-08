output "id" {
  description = "Identifier of the group in the Identity Store"
  value       = data.aws_identitystore_group.this.id
}

output "description" {
  description = "Description of the specified group"
  value       = data.aws_identitystore_group.this.description
}

output "display_name" {
  description = "Group's display name value"
  value       = data.aws_identitystore_group.this.display_name
}

output "external_ids" {
  description = "List of identifiers issued to this resource by an external identity provider"
  value       = data.aws_identitystore_group.this.external_ids
}

output "group_id" {
  description = "The identifier for a group in the Identity Store"
  value       = data.aws_identitystore_group.this.group_id
}

output "identity_store_id" {
  description = "Identity Store ID associated with the Single Sign-On Instance"
  value       = data.aws_identitystore_group.this.identity_store_id
}