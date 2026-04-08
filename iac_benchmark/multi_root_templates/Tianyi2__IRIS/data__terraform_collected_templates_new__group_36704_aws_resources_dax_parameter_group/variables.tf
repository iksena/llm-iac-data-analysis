variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the parameter group."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_dax_parameter_group, name must not be empty."
  }
}

variable "description" {
  description = "A description of the parameter group."
  type        = string
  default     = null
}

variable "parameters" {
  description = "The parameters of the parameter group."
  type = list(object({
    name  = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for param in var.parameters : length(param.name) > 0
    ])
    error_message = "resource_aws_dax_parameter_group, parameters name must not be empty."
  }

  validation {
    condition = alltrue([
      for param in var.parameters : length(param.value) > 0
    ])
    error_message = "resource_aws_dax_parameter_group, parameters value must not be empty."
  }
}