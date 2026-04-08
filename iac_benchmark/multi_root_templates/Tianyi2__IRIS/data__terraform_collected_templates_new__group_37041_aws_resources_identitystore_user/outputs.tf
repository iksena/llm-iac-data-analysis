output "user_id" {
  description = "The identifier for this user in the identity store."
  value       = aws_identitystore_user.this.user_id
}

output "external_ids" {
  description = "A list of identifiers issued to this resource by an external identity provider."
  value       = aws_identitystore_user.this.external_ids
}

output "display_name" {
  description = "The name that is typically displayed when the user is referenced."
  value       = aws_identitystore_user.this.display_name
}

output "identity_store_id" {
  description = "The globally unique identifier for the identity store that this user is in."
  value       = aws_identitystore_user.this.identity_store_id
}

output "user_name" {
  description = "A unique string used to identify the user."
  value       = aws_identitystore_user.this.user_name
}

output "name" {
  description = "Details about the user's full name."
  value       = aws_identitystore_user.this.name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_identitystore_user.this.region
}

output "addresses" {
  description = "Details about the user's address."
  value       = aws_identitystore_user.this.addresses
}

output "emails" {
  description = "Details about the user's email."
  value       = aws_identitystore_user.this.emails
}

output "phone_numbers" {
  description = "Details about the user's phone number."
  value       = aws_identitystore_user.this.phone_numbers
}

output "locale" {
  description = "The user's geographical region or location."
  value       = aws_identitystore_user.this.locale
}

output "nickname" {
  description = "An alternate name for the user."
  value       = aws_identitystore_user.this.nickname
}

output "preferred_language" {
  description = "The preferred language of the user."
  value       = aws_identitystore_user.this.preferred_language
}

output "profile_url" {
  description = "An URL that may be associated with the user."
  value       = aws_identitystore_user.this.profile_url
}

output "timezone" {
  description = "The user's time zone."
  value       = aws_identitystore_user.this.timezone
}

output "title" {
  description = "The user's title."
  value       = aws_identitystore_user.this.title
}

output "user_type" {
  description = "The user type."
  value       = aws_identitystore_user.this.user_type
}