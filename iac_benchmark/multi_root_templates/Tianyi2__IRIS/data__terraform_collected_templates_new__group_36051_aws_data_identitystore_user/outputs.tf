output "id" {
  description = "Identifier of the user in the Identity Store"
  value       = data.aws_identitystore_user.this.id
}

output "addresses" {
  description = "List of details about the user's address"
  value       = data.aws_identitystore_user.this.addresses
}

output "display_name" {
  description = "The name that is typically displayed when the user is referenced"
  value       = data.aws_identitystore_user.this.display_name
}

output "emails" {
  description = "List of details about the user's email"
  value       = data.aws_identitystore_user.this.emails
}

output "external_ids" {
  description = "List of identifiers issued to this resource by an external identity provider"
  value       = data.aws_identitystore_user.this.external_ids
}

output "locale" {
  description = "The user's geographical region or location"
  value       = data.aws_identitystore_user.this.locale
}

output "name" {
  description = "Details about the user's full name"
  value       = data.aws_identitystore_user.this.name
}

output "nickname" {
  description = "An alternate name for the user"
  value       = data.aws_identitystore_user.this.nickname
}

output "phone_numbers" {
  description = "List of details about the user's phone number"
  value       = data.aws_identitystore_user.this.phone_numbers
}

output "preferred_language" {
  description = "The preferred language of the user"
  value       = data.aws_identitystore_user.this.preferred_language
}

output "profile_url" {
  description = "An URL that may be associated with the user"
  value       = data.aws_identitystore_user.this.profile_url
}

output "timezone" {
  description = "The user's time zone"
  value       = data.aws_identitystore_user.this.timezone
}

output "title" {
  description = "The user's title"
  value       = data.aws_identitystore_user.this.title
}

output "user_name" {
  description = "User's user name value"
  value       = data.aws_identitystore_user.this.user_name
}

output "user_type" {
  description = "The user type"
  value       = data.aws_identitystore_user.this.user_type
}