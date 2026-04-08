variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "identity_pool_id" {
  description = "An identity pool ID."
  type        = string

  validation {
    condition     = var.identity_pool_id != null && var.identity_pool_id != ""
    error_message = "resource_aws_cognito_identity_pool_provider_principal_tag, identity_pool_id cannot be null or empty."
  }
}

variable "identity_provider_name" {
  description = "The name of the identity provider."
  type        = string

  validation {
    condition     = var.identity_provider_name != null && var.identity_provider_name != ""
    error_message = "resource_aws_cognito_identity_pool_provider_principal_tag, identity_provider_name cannot be null or empty."
  }
}

variable "principal_tags" {
  description = "String to string map of variables."
  type        = map(string)
  default     = {}
}

variable "use_defaults" {
  description = "Use default (username and clientID) attribute mappings."
  type        = bool
  default     = true
}