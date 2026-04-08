# Okta Application Configuration using Terraform
# Note: Requires Okta Terraform Provider

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
  }
}

# Configure Okta Provider
provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

# Okta Application for Resume Website
resource "okta_app_oauth" "resume_app" {
  label                      = "${var.project_name} Resume Website"
  type                       = "web"
  grant_types                = ["authorization_code", "refresh_token"]
  redirect_uris              = [
    "https://${var.domain_name}/auth/callback",
    "http://localhost:8080/auth/callback" # For local development
  ]
  post_logout_redirect_uris  = [
    "https://${var.domain_name}/auth/logout",
    "http://localhost:8080/auth/logout"
  ]
  response_types             = ["code"]
  
  # PKCE for security
  pkce_required = true
  
  # Token settings
  access_token_leeway        = 0
  refresh_token_leeway       = 0
  refresh_token_rotation     = "ROTATE"
  
  # Application settings
  auto_key_rotation         = true
  auto_submit_toolbar       = false
  hide_ios                  = false
  hide_web                  = false
  
  # Login settings
  login_mode               = "SPEC"
  login_scopes             = ["openid", "profile", "email"]
  
  # Consent settings
  consent_method           = "TRUSTED"
  
  lifecycle {
    ignore_changes = [users, groups]
  }
}

# Create a group for resume website friends
resource "okta_group" "resume_friends" {
  name        = "${var.project_name} Friends"
  description = "Friends who can access the resume website protected content"
}

# Application assignment to the friends group
resource "okta_app_group_assignment" "resume_friends" {
  app_id   = okta_app_oauth.resume_app.id
  group_id = okta_group.resume_friends.id
}

# Custom authorization server (optional, for advanced use cases)
resource "okta_auth_server" "resume_auth_server" {
  name        = "${var.project_name} Auth Server"
  description = "Authorization server for resume website"
  audiences   = ["api://${var.domain_name}"]
  
  # Only create if custom auth server is needed
  count = var.use_custom_auth_server ? 1 : 0
}

# Custom scope for protected content access
resource "okta_auth_server_scope" "protected_content" {
  count           = var.use_custom_auth_server ? 1 : 0
  auth_server_id  = okta_auth_server.resume_auth_server[0].id
  name            = "protected:read"
  description     = "Access to protected photos and documents"
  consent         = "IMPLICIT"
}

# Authorization policy
resource "okta_auth_server_policy" "resume_policy" {
  count           = var.use_custom_auth_server ? 1 : 0
  auth_server_id  = okta_auth_server.resume_auth_server[0].id
  name            = "Resume Access Policy"
  description     = "Policy for resume website access"
  priority        = 1
  client_whitelist = [okta_app_oauth.resume_app.client_id]
}

# Policy rule for friends group
resource "okta_auth_server_policy_rule" "friends_rule" {
  count                = var.use_custom_auth_server ? 1 : 0
  auth_server_id       = okta_auth_server.resume_auth_server[0].id
  policy_id            = okta_auth_server_policy.resume_policy[0].id
  name                 = "Friends Access Rule"
  priority             = 1
  grant_type_whitelist = ["authorization_code", "refresh_token"]
  scope_whitelist      = ["openid", "profile", "email", "protected:read"]
  
  group_whitelist = [okta_group.resume_friends.id]
  
  access_token_lifetime_minutes  = 60   # 1 hour
  refresh_token_lifetime_minutes = 10080 # 7 days
}

# Store Okta configuration in local file for deployment
resource "local_file" "okta_config" {
  content = jsonencode({
    domain        = var.okta_domain
    clientId      = okta_app_oauth.resume_app.client_id
    clientSecret  = okta_app_oauth.resume_app.client_secret
    issuer        = var.use_custom_auth_server ? okta_auth_server.resume_auth_server[0].issuer : "https://${var.okta_domain}/oauth2/default"
    redirectUri   = "https://${var.domain_name}/auth/callback"
    logoutUri     = "https://${var.domain_name}/auth/logout"
    scopes        = var.use_custom_auth_server ? ["openid", "profile", "email", "protected:read"] : ["openid", "profile", "email"]
  })
  filename = "${path.module}/../config/okta-config.json"
}