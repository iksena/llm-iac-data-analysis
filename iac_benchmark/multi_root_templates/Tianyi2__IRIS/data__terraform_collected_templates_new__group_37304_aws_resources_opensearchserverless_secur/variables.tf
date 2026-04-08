variable "name" {
  description = "Name of the policy."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_opensearchserverless_security_config, name must not be empty."
  }
}

variable "type" {
  description = "Type of configuration. Must be saml."
  type        = string

  validation {
    condition     = var.type == "saml"
    error_message = "resource_aws_opensearchserverless_security_config, type must be 'saml'."
  }
}

variable "description" {
  description = "Description of the security configuration."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "saml_options" {
  description = "Configuration block for SAML options."
  type = object({
    metadata        = string
    group_attribute = optional(string)
    session_timeout = optional(number)
    user_attribute  = optional(string)
  })

  validation {
    condition     = var.saml_options.metadata != null && length(var.saml_options.metadata) > 0
    error_message = "resource_aws_opensearchserverless_security_config, saml_options.metadata is required and must not be empty."
  }

  validation {
    condition = var.saml_options.session_timeout == null || (
      var.saml_options.session_timeout >= 5 && var.saml_options.session_timeout <= 720
    )
    error_message = "resource_aws_opensearchserverless_security_config, saml_options.session_timeout must be between 5 and 720 minutes."
  }
}