variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name for the alias you are creating."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_sfn_alias, name must not be empty."
  }
}

variable "description" {
  description = "Description of the alias."
  type        = string
  default     = null
}

variable "routing_configuration" {
  description = "The StateMachine alias' route configuration settings."
  type = list(object({
    state_machine_version_arn = string
    weight                    = number
  }))

  validation {
    condition     = length(var.routing_configuration) > 0
    error_message = "resource_aws_sfn_alias, routing_configuration must contain at least one configuration."
  }

  validation {
    condition = alltrue([
      for config in var.routing_configuration :
      config.state_machine_version_arn != null && config.state_machine_version_arn != ""
    ])
    error_message = "resource_aws_sfn_alias, state_machine_version_arn must not be empty in routing_configuration."
  }

  validation {
    condition = alltrue([
      for config in var.routing_configuration :
      config.weight >= 0 && config.weight <= 100
    ])
    error_message = "resource_aws_sfn_alias, weight must be between 0 and 100 in routing_configuration."
  }

  validation {
    condition     = sum([for config in var.routing_configuration : config.weight]) == 100
    error_message = "resource_aws_sfn_alias, routing_configuration weights must sum to 100."
  }
}