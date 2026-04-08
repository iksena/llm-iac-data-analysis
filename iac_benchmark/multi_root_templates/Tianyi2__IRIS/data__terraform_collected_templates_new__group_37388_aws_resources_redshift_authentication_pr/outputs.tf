output "id" {
  description = "The name of the authentication profile."
  value       = aws_redshift_authentication_profile.this.id
}

output "region" {
  description = "The AWS region where the authentication profile is created."
  value       = aws_redshift_authentication_profile.this.region
}

output "authentication_profile_name" {
  description = "The name of the authentication profile."
  value       = aws_redshift_authentication_profile.this.authentication_profile_name
}

output "authentication_profile_content" {
  description = "The content of the authentication profile in JSON format."
  value       = aws_redshift_authentication_profile.this.authentication_profile_content
  sensitive   = true
}