output "users" {
  description = "List of Identity Store Users"
  value       = data.aws_identitystore_users.this.users
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_identitystore_users.this.region
}

output "identity_store_id" {
  description = "Identity Store ID associated with the Single Sign-On Instance"
  value       = data.aws_identitystore_users.this.identity_store_id
}

output "users_addresses" {
  description = "List of details about each user's address"
  value       = [for user in data.aws_identitystore_users.this.users : user.addresses]
}

output "users_display_names" {
  description = "List of display names for all users"
  value       = [for user in data.aws_identitystore_users.this.users : user.display_name]
}

output "users_emails" {
  description = "List of details about each user's email"
  value       = [for user in data.aws_identitystore_users.this.users : user.emails]
}

output "users_external_ids" {
  description = "List of external identifiers for each user"
  value       = [for user in data.aws_identitystore_users.this.users : user.external_ids]
}

output "users_locales" {
  description = "List of geographical regions or locations for all users"
  value       = [for user in data.aws_identitystore_users.this.users : user.locale]
}

output "users_names" {
  description = "List of details about each user's full name"
  value       = [for user in data.aws_identitystore_users.this.users : user.name]
}

output "users_nicknames" {
  description = "List of alternate names for all users"
  value       = [for user in data.aws_identitystore_users.this.users : user.nickname]
}

output "users_phone_numbers" {
  description = "List of details about each user's phone number"
  value       = [for user in data.aws_identitystore_users.this.users : user.phone_numbers]
}

output "users_preferred_languages" {
  description = "List of preferred languages for all users"
  value       = [for user in data.aws_identitystore_users.this.users : user.preferred_language]
}

output "users_profile_urls" {
  description = "List of profile URLs for all users"
  value       = [for user in data.aws_identitystore_users.this.users : user.profile_url]
}

output "users_timezones" {
  description = "List of time zones for all users"
  value       = [for user in data.aws_identitystore_users.this.users : user.timezone]
}

output "users_titles" {
  description = "List of titles for all users"
  value       = [for user in data.aws_identitystore_users.this.users : user.title]
}

output "users_user_ids" {
  description = "List of user identifiers in the Identity Store"
  value       = [for user in data.aws_identitystore_users.this.users : user.user_id]
}

output "users_user_names" {
  description = "List of user names for all users"
  value       = [for user in data.aws_identitystore_users.this.users : user.user_name]
}

output "users_user_types" {
  description = "List of user types for all users"
  value       = [for user in data.aws_identitystore_users.this.users : user.user_type]
}