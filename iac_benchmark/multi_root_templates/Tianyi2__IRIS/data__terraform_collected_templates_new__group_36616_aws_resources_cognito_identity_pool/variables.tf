variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "identity_pool_name" {
  description = "The Cognito Identity Pool name"
  type        = string

  validation {
    condition     = length(var.identity_pool_name) > 0 && length(var.identity_pool_name) <= 128
    error_message = "resource_aws_cognito_identity_pool, identity_pool_name must be between 1 and 128 characters long."
  }
}

variable "allow_unauthenticated_identities" {
  description = "Whether the identity pool supports unauthenticated logins or not"
  type        = bool
}

variable "allow_classic_flow" {
  description = "Enables or disables the classic / basic authentication flow"
  type        = bool
  default     = false
}

variable "developer_provider_name" {
  description = "The domain by which Cognito will refer to your users"
  type        = string
  default     = null

  validation {
    condition = var.developer_provider_name == null || (
      length(var.developer_provider_name) >= 1 &&
      length(var.developer_provider_name) <= 128 &&
      can(regex("^[\\w\\._-]+$", var.developer_provider_name))
    )
    error_message = "resource_aws_cognito_identity_pool, developer_provider_name must be 1-128 characters long and contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "cognito_identity_providers" {
  description = "An array of Amazon Cognito Identity user pools and their client IDs"
  type = list(object({
    client_id               = optional(string)
    provider_name           = optional(string)
    server_side_token_check = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for provider in var.cognito_identity_providers :
      provider.client_id == null || can(regex("^[\\w+=/,.@-]+$", provider.client_id))
    ])
    error_message = "resource_aws_cognito_identity_pool, cognito_identity_providers client_id must contain only valid characters."
  }

  validation {
    condition = alltrue([
      for provider in var.cognito_identity_providers :
      provider.provider_name == null || can(regex("^cognito-idp\\.[a-z0-9-]+\\.amazonaws\\.com/[a-zA-Z0-9_.-]+$", provider.provider_name))
    ])
    error_message = "resource_aws_cognito_identity_pool, cognito_identity_providers provider_name must be a valid Cognito Identity Provider name."
  }
}

variable "openid_connect_provider_arns" {
  description = "Set of OpendID Connect provider ARNs"
  type        = set(string)
  default     = null

  validation {
    condition = var.openid_connect_provider_arns == null || alltrue([
      for arn in var.openid_connect_provider_arns :
      can(regex("^arn:aws:iam::[0-9]{12}:oidc-provider/.+$", arn))
    ])
    error_message = "resource_aws_cognito_identity_pool, openid_connect_provider_arns must be valid OIDC provider ARNs."
  }
}

variable "saml_provider_arns" {
  description = "An array of Amazon Resource Names (ARNs) of the SAML provider for your identity"
  type        = list(string)
  default     = null

  validation {
    condition = var.saml_provider_arns == null || alltrue([
      for arn in var.saml_provider_arns :
      can(regex("^arn:aws:iam::[0-9]{12}:saml-provider/.+$", arn))
    ])
    error_message = "resource_aws_cognito_identity_pool, saml_provider_arns must be valid SAML provider ARNs."
  }
}

variable "supported_login_providers" {
  description = "Key-Value pairs mapping provider names to provider app IDs"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for provider in keys(var.supported_login_providers) :
      contains([
        "graph.facebook.com",
        "accounts.google.com",
        "www.amazon.com",
        "api.twitter.com",
        "appleid.apple.com"
      ], provider)
    ])
    error_message = "resource_aws_cognito_identity_pool, supported_login_providers keys must be valid login provider domains."
  }
}

variable "tags" {
  description = "A map of tags to assign to the Identity Pool"
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.tags) <= 50
    error_message = "resource_aws_cognito_identity_pool, tags cannot exceed 50 key-value pairs."
  }

  validation {
    condition = alltrue([
      for key in keys(var.tags) :
      length(key) <= 128 && length(key) >= 1
    ])
    error_message = "resource_aws_cognito_identity_pool, tags keys must be between 1 and 128 characters long."
  }

  validation {
    condition = alltrue([
      for value in values(var.tags) :
      length(value) <= 256
    ])
    error_message = "resource_aws_cognito_identity_pool, tags values must be no more than 256 characters long."
  }
}