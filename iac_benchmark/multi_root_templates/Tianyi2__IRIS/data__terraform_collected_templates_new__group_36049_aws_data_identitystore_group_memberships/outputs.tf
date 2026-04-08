output "group_memberships" {
  description = "A list of group membership objects."
  value       = data.aws_identitystore_group_memberships.this.group_memberships
}

output "group_id" {
  description = "The identifier for a group in the Identity Store."
  value       = data.aws_identitystore_group_memberships.this.group_id
}

output "identity_store_id" {
  description = "Identity Store ID associated with the Single Sign-On Instance."
  value       = data.aws_identitystore_group_memberships.this.identity_store_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_identitystore_group_memberships.this.region
}