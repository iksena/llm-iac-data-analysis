variable "policy_reference_name" {
  description = "The identifier to be used when working with policy rules"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.policy_reference_name))
    error_message = "resource_aws_verifiedaccess_trust_provider, policy_reference_name must contain only alphanumeric characters, dots, underscores, and hyphens."
  }
}

variable "trust_provider_type" {
  description = "The type of trust provider can be either user or device-based"
  type        = string

  validation {
    condition     = contains(["user", "device"], var.trust_provider_type)
    error_message = "resource_aws_verifiedaccess_trust_provider, trust_provider_type must be either 'user' or 'device'."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "A description for the AWS Verified Access trust provider"
  type        = string
  default     = null
}

variable "device_trust_provider_type" {
  description = "The type of device-based trust provider"
  type        = string
  default     = null

  validation {
    condition     = var.device_trust_provider_type == null || contains(["crowdstrike", "jamf", "jumpcloud"], var.device_trust_provider_type)
    error_message = "resource_aws_verifiedaccess_trust_provider, device_trust_provider_type must be one of 'crowdstrike', 'jamf', or 'jumpcloud'."
  }
}

variable "user_trust_provider_type" {
  description = "The type of user-based trust provider"
  type        = string
  default     = null

  validation {
    condition     = var.user_trust_provider_type == null || contains(["iam-identity-center", "oidc"], var.user_trust_provider_type)
    error_message = "resource_aws_verifiedaccess_trust_provider, user_trust_provider_type must be either 'iam-identity-center' or 'oidc'."
  }
}

variable "device_options" {
  description = "A block of options for device identity based trust providers"
  type = object({
    tenant_id = optional(string)
  })
  default = null
}

variable "native_application_oidc_options" {
  description = "The OpenID Connect details for an Native Application OIDC, user-identity based trust provider"
  type = object({
    client_id              = optional(string)
    client_secret          = optional(string)
    issuer                 = optional(string)
    authorization_endpoint = optional(string)
    token_endpoint         = optional(string)
    user_info_endpoint     = optional(string)
    scope                  = optional(string)
  })
  default = null
}

variable "oidc_options" {
  description = "The OpenID Connect details for an oidc-type, user-identity based trust provider"
  type = object({
    client_id              = optional(string)
    client_secret          = optional(string)
    issuer                 = optional(string)
    authorization_endpoint = optional(string)
    token_endpoint         = optional(string)
    user_info_endpoint     = optional(string)
    scope                  = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "60m")
    update = optional(string, "180m")
    delete = optional(string, "90m")
  })
  default = {
    create = "60m"
    update = "180m"
    delete = "90m"
  }
}