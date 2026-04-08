# Okta Terraform Variables

variable "okta_org_name" {
  description = "Okta organization name (e.g., 'dev-123456')"
  type        = string
}

variable "okta_base_url" {
  description = "Okta base URL (e.g., 'oktapreview.com' or 'okta.com')"
  type        = string
  default     = "okta.com"
}

variable "okta_api_token" {
  description = "Okta API token for Terraform operations"
  type        = string
  sensitive   = true
}

variable "okta_domain" {
  description = "Full Okta domain (e.g., 'dev-123456.okta.com')"
  type        = string
}

variable "domain_name" {
  description = "Your website domain name"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "Resume"
}

variable "use_custom_auth_server" {
  description = "Whether to create a custom authorization server"
  type        = bool
  default     = false
}

# Optional: Environment-specific settings
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "enable_pkce" {
  description = "Enable PKCE for additional security"
  type        = bool
  default     = true
}

variable "token_lifetime_minutes" {
  description = "Access token lifetime in minutes"
  type        = number
  default     = 60
}

variable "refresh_token_lifetime_minutes" {
  description = "Refresh token lifetime in minutes"
  type        = number
  default     = 10080 # 7 days
}