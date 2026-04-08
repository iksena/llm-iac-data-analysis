variable "name" {
  description = "Configuration manager name."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ssmquicksetup_configuration_manager, name must not be empty."
  }
}

variable "description" {
  description = "Description of the configuration manager."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags assigned to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "configuration_definition" {
  description = "Definition of the Quick Setup configuration that the configuration manager deploys."
  type = object({
    local_deployment_administration_role_arn = optional(string)
    local_deployment_execution_role_name     = optional(string)
    parameters                               = map(string)
    type                                     = string
    type_version                             = optional(string)
  })

  validation {
    condition     = var.configuration_definition.type != ""
    error_message = "resource_aws_ssmquicksetup_configuration_manager, configuration_definition.type must not be empty."
  }

  validation {
    condition     = length(var.configuration_definition.parameters) > 0
    error_message = "resource_aws_ssmquicksetup_configuration_manager, configuration_definition.parameters must not be empty."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "20m")
    update = optional(string, "20m")
    delete = optional(string, "20m")
  })
  default = null
}