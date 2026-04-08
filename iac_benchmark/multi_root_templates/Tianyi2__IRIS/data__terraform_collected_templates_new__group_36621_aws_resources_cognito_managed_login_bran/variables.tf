variable "client_id" {
  description = "App client that the branding style is for"
  type        = string
  validation {
    condition     = length(var.client_id) > 0
    error_message = "resource_aws_cognito_managed_login_branding, client_id must not be empty"
  }
}

variable "user_pool_id" {
  description = "User pool the client belongs to"
  type        = string
  validation {
    condition     = length(var.user_pool_id) > 0
    error_message = "resource_aws_cognito_managed_login_branding, user_pool_id must not be empty"
  }
}

variable "asset" {
  description = "Image files to apply to roles like backgrounds, logos, and icons"
  type = list(object({
    bytes       = optional(string)
    category    = string
    color_mode  = string
    extensions  = string
    resource_id = optional(string)
  }))
  default = null
  validation {
    condition = var.asset == null || alltrue([
      for a in coalesce(var.asset, []) : contains(["LIGHT", "DARK", "DYNAMIC"], a.color_mode)
    ])
    error_message = "resource_aws_cognito_managed_login_branding, asset color_mode must be one of: LIGHT, DARK, DYNAMIC"
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "settings" {
  description = "JSON document with the settings to apply to the style"
  type        = string
  default     = null
  validation {
    condition     = var.settings == null || can(jsondecode(var.settings))
    error_message = "resource_aws_cognito_managed_login_branding, settings must be a valid JSON document"
  }
}

variable "use_cognito_provided_values" {
  description = "When true, applies the default branding style options"
  type        = bool
  default     = null
}