output "creation_date" {
  description = "The creation date in RFC3339 format for the UI customization."
  value       = aws_cognito_user_pool_ui_customization.this.creation_date
}

output "css_version" {
  description = "The CSS version number."
  value       = aws_cognito_user_pool_ui_customization.this.css_version
}

output "image_url" {
  description = "The logo image URL for the UI customization."
  value       = aws_cognito_user_pool_ui_customization.this.image_url
}

output "last_modified_date" {
  description = "The last-modified date in RFC3339 format for the UI customization."
  value       = aws_cognito_user_pool_ui_customization.this.last_modified_date
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_cognito_user_pool_ui_customization.this.region
}

output "client_id" {
  description = "The client ID for the client app."
  value       = aws_cognito_user_pool_ui_customization.this.client_id
}

output "css" {
  description = "The CSS values in the UI customization."
  value       = aws_cognito_user_pool_ui_customization.this.css
}

output "image_file" {
  description = "The uploaded logo image for the UI customization."
  value       = aws_cognito_user_pool_ui_customization.this.image_file
  sensitive   = true
}

output "user_pool_id" {
  description = "The user pool ID for the user pool."
  value       = aws_cognito_user_pool_ui_customization.this.user_pool_id
}