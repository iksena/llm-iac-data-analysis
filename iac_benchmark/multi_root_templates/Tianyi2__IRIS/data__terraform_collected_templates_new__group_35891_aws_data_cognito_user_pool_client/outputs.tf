output "client_id" {
  description = "Client Id of the user pool"
  value       = data.aws_cognito_user_pool_client.this.client_id
}

output "user_pool_id" {
  description = "User pool the client belongs to"
  value       = data.aws_cognito_user_pool_client.this.user_pool_id
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_cognito_user_pool_client.this.region
}

output "access_token_validity" {
  description = "Time limit, between 5 minutes and 1 day, after which the access token is no longer valid and cannot be used"
  value       = data.aws_cognito_user_pool_client.this.access_token_validity
}

output "allowed_oauth_flows_user_pool_client" {
  description = "Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools"
  value       = data.aws_cognito_user_pool_client.this.allowed_oauth_flows_user_pool_client
}

output "allowed_oauth_flows" {
  description = "List of allowed OAuth flows (code, implicit, client_credentials)"
  value       = data.aws_cognito_user_pool_client.this.allowed_oauth_flows
}

output "allowed_oauth_scopes" {
  description = "List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin)"
  value       = data.aws_cognito_user_pool_client.this.allowed_oauth_scopes
}

output "analytics_configuration" {
  description = "Configuration block for Amazon Pinpoint analytics for collecting metrics for this user pool"
  value       = data.aws_cognito_user_pool_client.this.analytics_configuration
}

output "callback_urls" {
  description = "List of allowed callback URLs for the identity providers"
  value       = data.aws_cognito_user_pool_client.this.callback_urls
}

output "client_secret" {
  description = "Client secret of the user pool client"
  value       = data.aws_cognito_user_pool_client.this.client_secret
  sensitive   = true
}

output "default_redirect_uri" {
  description = "Default redirect URI. Must be in the list of callback URLs"
  value       = data.aws_cognito_user_pool_client.this.default_redirect_uri
}

output "enable_token_revocation" {
  description = "Enables or disables token revocation"
  value       = data.aws_cognito_user_pool_client.this.enable_token_revocation
}

output "explicit_auth_flows" {
  description = "List of authentication flows"
  value       = data.aws_cognito_user_pool_client.this.explicit_auth_flows
}

output "generate_secret" {
  description = "Should an application secret be generated"
  value       = data.aws_cognito_user_pool_client.this.generate_secret
}

output "id_token_validity" {
  description = "Time limit, between 5 minutes and 1 day, after which the ID token is no longer valid and cannot be used"
  value       = data.aws_cognito_user_pool_client.this.id_token_validity
}

output "logout_urls" {
  description = "List of allowed logout URLs for the identity providers"
  value       = data.aws_cognito_user_pool_client.this.logout_urls
}

output "prevent_user_existence_errors" {
  description = "Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool"
  value       = data.aws_cognito_user_pool_client.this.prevent_user_existence_errors
}

output "read_attributes" {
  description = "List of user pool attributes the application client can read from"
  value       = data.aws_cognito_user_pool_client.this.read_attributes
}

output "refresh_token_rotation" {
  description = "A block that specifies the configuration of refresh token rotation"
  value       = data.aws_cognito_user_pool_client.this.refresh_token_rotation
}

output "refresh_token_validity" {
  description = "Time limit in days refresh tokens are valid for"
  value       = data.aws_cognito_user_pool_client.this.refresh_token_validity
}

output "supported_identity_providers" {
  description = "List of provider names for the identity providers that are supported on this client"
  value       = data.aws_cognito_user_pool_client.this.supported_identity_providers
}

output "token_validity_units" {
  description = "Configuration block for units in which the validity times are represented in"
  value       = data.aws_cognito_user_pool_client.this.token_validity_units
}

output "write_attributes" {
  description = "List of user pool attributes the application client can write to"
  value       = data.aws_cognito_user_pool_client.this.write_attributes
}