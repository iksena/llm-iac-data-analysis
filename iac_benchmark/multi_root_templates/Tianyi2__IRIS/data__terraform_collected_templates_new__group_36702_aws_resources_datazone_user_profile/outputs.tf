output "details" {
  description = "Details about the user profile."
  value       = aws_datazone_user_profile.this.details
}

output "id" {
  description = "The user profile identifier."
  value       = aws_datazone_user_profile.this.id
}

output "type" {
  description = "The user profile type."
  value       = aws_datazone_user_profile.this.type
}