variable "user_pool_id" {
  description = "The user pool id"
  type        = string

  validation {
    condition     = length(var.user_pool_id) > 0
    error_message = "resource_aws_cognito_identity_provider, user_pool_id must not be empty."
  }
}

variable "provider_name" {
  description = "The provider name"
  type        = string

  validation {
    condition     = length(var.provider_name) > 0
    error_message = "resource_aws_cognito_identity_provider, provider_name must not be empty."
  }
}

variable "provider_type" {
  description = "The provider type. See AWS API for valid values"
  type        = string

  validation {
    condition = contains([
      "SAML",
      "Facebook",
      "Google",
      "LoginWithAmazon",
      "SignInWithApple",
      "OIDC"
    ], var.provider_type)
    error_message = "resource_aws_cognito_identity_provider, provider_type must be one of: SAML, Facebook, Google, LoginWithAmazon, SignInWithApple, OIDC."
  }
}

variable "attribute_mapping" {
  description = "The map of attribute mapping of user pool attributes"
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.attribute_mapping)
    error_message = "resource_aws_cognito_identity_provider, attribute_mapping must be a valid map of strings."
  }
}

variable "idp_identifiers" {
  description = "The list of identity providers"
  type        = list(string)
  default     = []

  validation {
    condition     = can(var.idp_identifiers)
    error_message = "resource_aws_cognito_identity_provider, idp_identifiers must be a valid list of strings."
  }
}

variable "provider_details" {
  description = "The map of identity details, such as access token"
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.provider_details)
    error_message = "resource_aws_cognito_identity_provider, provider_details must be a valid map of strings."
  }
}