variable "name" {
  description = "The name of the configuration policy"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_securityhub_configuration_policy, name must be a non-empty string."
  }
}

variable "description" {
  description = "The description of the configuration policy"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "service_enabled" {
  description = "Indicates whether Security Hub is enabled in the policy"
  type        = bool

  validation {
    condition     = var.service_enabled != null
    error_message = "resource_aws_securityhub_configuration_policy, service_enabled is required."
  }
}

variable "enabled_standard_arns" {
  description = "A list that defines which security standards are enabled in the configuration policy"
  type        = list(string)
  default     = null

  validation {
    condition = var.enabled_standard_arns == null || alltrue([
      for arn in var.enabled_standard_arns : can(regex("^arn:aws:securityhub:", arn))
    ])
    error_message = "resource_aws_securityhub_configuration_policy, enabled_standard_arns must contain valid Security Hub standard ARNs."
  }
}

variable "security_controls_configuration" {
  description = "Defines which security controls are enabled in the configuration policy and any customizations to parameters affecting them"
  type = object({
    disabled_control_identifiers = optional(list(string))
    enabled_control_identifiers  = optional(list(string))
    security_control_custom_parameter = optional(list(object({
      security_control_id = string
      parameter = list(object({
        name       = string
        value_type = string
        bool = optional(object({
          value = bool
        }))
        double = optional(object({
          value = number
        }))
        enum = optional(object({
          value = string
        }))
        enum_list = optional(object({
          value = list(string)
        }))
        int = optional(object({
          value = number
        }))
        int_list = optional(object({
          value = list(number)
        }))
        string = optional(object({
          value = string
        }))
        string_list = optional(object({
          value = list(string)
        }))
      }))
    })))
  })
  default = null

  validation {
    condition = var.security_controls_configuration == null || (
      (var.security_controls_configuration.disabled_control_identifiers == null) !=
      (var.security_controls_configuration.enabled_control_identifiers == null)
    )
    error_message = "resource_aws_securityhub_configuration_policy, security_controls_configuration disabled_control_identifiers and enabled_control_identifiers are mutually exclusive."
  }

  validation {
    condition = var.security_controls_configuration == null || (
      var.security_controls_configuration.security_control_custom_parameter == null ||
      alltrue([
        for param in var.security_controls_configuration.security_control_custom_parameter :
        length(param.security_control_id) > 0
      ])
    )
    error_message = "resource_aws_securityhub_configuration_policy, security_controls_configuration security_control_id must be a non-empty string."
  }

  validation {
    condition = var.security_controls_configuration == null || (
      var.security_controls_configuration.security_control_custom_parameter == null ||
      alltrue([
        for custom_param in var.security_controls_configuration.security_control_custom_parameter :
        alltrue([
          for param in custom_param.parameter :
          contains(["DEFAULT", "CUSTOM"], param.value_type)
        ])
      ])
    )
    error_message = "resource_aws_securityhub_configuration_policy, security_controls_configuration parameter value_type must be either 'DEFAULT' or 'CUSTOM'."
  }

  validation {
    condition = var.security_controls_configuration == null || (
      var.security_controls_configuration.security_control_custom_parameter == null ||
      alltrue([
        for custom_param in var.security_controls_configuration.security_control_custom_parameter :
        alltrue([
          for param in custom_param.parameter :
          length(param.name) > 0
        ])
      ])
    )
    error_message = "resource_aws_securityhub_configuration_policy, security_controls_configuration parameter name must be a non-empty string."
  }
}