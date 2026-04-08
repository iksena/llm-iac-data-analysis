variable "config_rule_name" {
  description = "Name of the AWS Config rule"
  type        = string

  validation {
    condition     = length(var.config_rule_name) > 0
    error_message = "resource_aws_config_remediation_configuration, config_rule_name must not be empty."
  }
}

variable "target_id" {
  description = "Target ID is the name of the public document"
  type        = string

  validation {
    condition     = length(var.target_id) > 0
    error_message = "resource_aws_config_remediation_configuration, target_id must not be empty."
  }
}

variable "target_type" {
  description = "Type of the target. Target executes remediation. For example, SSM document"
  type        = string

  validation {
    condition     = length(var.target_type) > 0
    error_message = "resource_aws_config_remediation_configuration, target_type must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "automatic" {
  description = "Remediation is triggered automatically if true"
  type        = bool
  default     = null
}

variable "maximum_automatic_attempts" {
  description = "Maximum number of failed attempts for auto-remediation. If you do not select a number, the default is 5"
  type        = number
  default     = null

  validation {
    condition     = var.maximum_automatic_attempts == null || (var.maximum_automatic_attempts >= 1 && var.maximum_automatic_attempts <= 25)
    error_message = "resource_aws_config_remediation_configuration, maximum_automatic_attempts must be between 1 and 25."
  }
}

variable "resource_type" {
  description = "Type of resource"
  type        = string
  default     = null
}

variable "retry_attempt_seconds" {
  description = "Maximum time in seconds that AWS Config runs auto-remediation. If you do not select a number, the default is 60 seconds"
  type        = number
  default     = null

  validation {
    condition     = var.retry_attempt_seconds == null || (var.retry_attempt_seconds >= 1 && var.retry_attempt_seconds <= 2678400)
    error_message = "resource_aws_config_remediation_configuration, retry_attempt_seconds must be between 1 and 2678400."
  }
}

variable "target_version" {
  description = "Version of the target. For example, version of the SSM document"
  type        = string
  default     = null
}

variable "execution_controls" {
  description = "Configuration block for execution controls"
  type = object({
    ssm_controls = object({
      concurrent_execution_rate_percentage = optional(number)
      error_percentage                     = optional(number)
    })
  })
  default = null

  validation {
    condition = var.execution_controls == null || (
      var.execution_controls.ssm_controls.concurrent_execution_rate_percentage == null ||
      (var.execution_controls.ssm_controls.concurrent_execution_rate_percentage >= 1 && var.execution_controls.ssm_controls.concurrent_execution_rate_percentage <= 100)
    )
    error_message = "resource_aws_config_remediation_configuration, concurrent_execution_rate_percentage must be between 1 and 100."
  }

  validation {
    condition = var.execution_controls == null || (
      var.execution_controls.ssm_controls.error_percentage == null ||
      (var.execution_controls.ssm_controls.error_percentage >= 1 && var.execution_controls.ssm_controls.error_percentage <= 100)
    )
    error_message = "resource_aws_config_remediation_configuration, error_percentage must be between 1 and 100."
  }
}

variable "parameters" {
  description = "List of parameter blocks. Each parameter block supports name, resource_value, static_value, and static_values"
  type = list(object({
    name           = string
    resource_value = optional(string)
    static_value   = optional(string)
    static_values  = optional(list(string))
  }))
  default = []

  validation {
    condition = alltrue([
      for param in var.parameters : length(param.name) > 0
    ])
    error_message = "resource_aws_config_remediation_configuration, parameter name must not be empty."
  }

  validation {
    condition = alltrue([
      for param in var.parameters : (
        (param.resource_value != null ? 1 : 0) +
        (param.static_value != null ? 1 : 0) +
        (param.static_values != null ? 1 : 0)
      ) <= 1
    ])
    error_message = "resource_aws_config_remediation_configuration, parameter must specify only one of resource_value, static_value, or static_values."
  }

  validation {
    condition = alltrue([
      for param in var.parameters : (
        (param.resource_value != null ? 1 : 0) +
        (param.static_value != null ? 1 : 0) +
        (param.static_values != null ? 1 : 0)
      ) >= 1
    ])
    error_message = "resource_aws_config_remediation_configuration, parameter must specify one of resource_value, static_value, or static_values."
  }
}