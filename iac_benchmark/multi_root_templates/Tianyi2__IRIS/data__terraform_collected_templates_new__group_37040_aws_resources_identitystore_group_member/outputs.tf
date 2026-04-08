output "membership_id" {
  description = "The identifier of the newly created group membership in the Identity Store."
  value       = aws_identitystore_group_membership.this.membership_id
}

output "identity_store_id" {
  description = "Identity Store ID associated with the Single Sign-On Instance."
  value       = aws_identitystore_group_membership.this.identity_store_id
}

output "group_id" {
  description = "The identifier for a group in the Identity Store."
  value       = aws_identitystore_group_membership.this.group_id
}

output "member_id" {
  description = "The identifier for a user in the Identity Store."
  value       = aws_identitystore_group_membership.this.member_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_identitystore_group_membership.this.region
}