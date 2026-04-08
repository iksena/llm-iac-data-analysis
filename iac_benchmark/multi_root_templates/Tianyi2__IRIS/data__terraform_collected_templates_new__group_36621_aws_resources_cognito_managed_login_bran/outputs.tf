output "managed_login_branding_id" {
  description = "ID of the managed login branding style"
  value       = aws_cognito_managed_login_branding.this.managed_login_branding_id
}

output "settings_all" {
  description = "Settings including Amazon Cognito defaults"
  value       = aws_cognito_managed_login_branding.this.settings_all
}

output "client_id" {
  description = "App client that the branding style is for"
  value       = aws_cognito_managed_login_branding.this.client_id
}

output "user_pool_id" {
  description = "User pool the client belongs to"
  value       = aws_cognito_managed_login_branding.this.user_pool_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_cognito_managed_login_branding.this.region
}

output "settings" {
  description = "JSON document with the settings applied to the style"
  value       = aws_cognito_managed_login_branding.this.settings
}

output "use_cognito_provided_values" {
  description = "Whether default branding style options are applied"
  value       = aws_cognito_managed_login_branding.this.use_cognito_provided_values
}

output "asset" {
  description = "Image files applied to roles like backgrounds, logos, and icons"
  value       = aws_cognito_managed_login_branding.this.asset
}