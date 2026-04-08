variable "control_identifier" {
  description = "The ARN of the control. Only Strongly recommended and Elective controls are permitted, with the exception of the Region deny guardrail."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:controltower:", var.control_identifier))
    error_message = "resource_aws_controltower_control, control_identifier must be a valid Control Tower control ARN starting with 'arn:aws:controltower:'."
  }
}

variable "target_identifier" {
  description = "The ARN of the organizational unit."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:organizations:", var.target_identifier))
    error_message = "resource_aws_controltower_control, target_identifier must be a valid Organizations organizational unit ARN starting with 'arn:aws:organizations:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "parameters" {
  description = "Parameter values which are specified to configure the control when you enable it."
  type = list(object({
    key   = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for param in var.parameters : param.key != null && param.key != ""
    ])
    error_message = "resource_aws_controltower_control, parameters each parameter must have a non-empty key."
  }

  validation {
    condition = alltrue([
      for param in var.parameters : param.value != null && param.value != ""
    ])
    error_message = "resource_aws_controltower_control, parameters each parameter must have a non-empty value."
  }
}