output "group_id" {
  description = "The identifier of the newly created group in the identity store."
  value       = aws_identitystore_group.this.group_id
}

output "external_ids" {
  description = "A list of external IDs that contains the identifiers issued to this resource by an external identity provider."
  value       = aws_identitystore_group.this.external_ids
}

output "identity_store_id" {
  description = "The globally unique identifier for the identity store."
  value       = aws_identitystore_group.this.identity_store_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_identitystore_group.this.region
}

output "display_name" {
  description = "The name of the group."
  value       = aws_identitystore_group.this.display_name
}

output "description" {
  description = "The description of the group."
  value       = aws_identitystore_group.this.description
}