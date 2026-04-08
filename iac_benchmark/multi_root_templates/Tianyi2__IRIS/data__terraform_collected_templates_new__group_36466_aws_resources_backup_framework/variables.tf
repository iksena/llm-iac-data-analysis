variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The unique name of the framework. The name must be between 1 and 256 characters, starting with a letter, and consisting of letters, numbers, and underscores."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.name)) && length(var.name) >= 1 && length(var.name) <= 256
    error_message = "resource_aws_backup_framework, name must be between 1 and 256 characters, starting with a letter, and consisting of letters, numbers, and underscores."
  }
}

variable "description" {
  description = "The description of the framework with a maximum of 1,024 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_backup_framework, description must have a maximum of 1,024 characters."
  }
}

variable "control" {
  description = "One or more control blocks that make up the framework. Each control in the list has a name, input parameters, and scope."
  type = list(object({
    name = string
    input_parameter = optional(list(object({
      name  = optional(string)
      value = optional(string)
    })), [])
    scope = optional(object({
      compliance_resource_ids   = optional(list(string))
      compliance_resource_types = optional(list(string))
      tags                      = optional(map(string))
    }))
  }))

  validation {
    condition     = length(var.control) > 0
    error_message = "resource_aws_backup_framework, control is required and must contain at least one control block."
  }

  validation {
    condition = alltrue([
      for ctrl in var.control : ctrl.name != null && length(ctrl.name) >= 1 && length(ctrl.name) <= 256
    ])
    error_message = "resource_aws_backup_framework, control name is required and must be between 1 and 256 characters."
  }

  validation {
    condition = alltrue([
      for ctrl in var.control :
      ctrl.scope == null || (
        ctrl.scope.compliance_resource_ids == null || (
          length(ctrl.scope.compliance_resource_ids) >= 1 && length(ctrl.scope.compliance_resource_ids) <= 100
        )
      )
    ])
    error_message = "resource_aws_backup_framework, control scope compliance_resource_ids must have minimum number of 1 item and maximum number of 100 items."
  }

  validation {
    condition = alltrue([
      for ctrl in var.control :
      ctrl.scope == null || ctrl.scope.tags == null || length(ctrl.scope.tags) <= 1
    ])
    error_message = "resource_aws_backup_framework, control scope tags can have a maximum of one key-value pair."
  }
}

variable "tags" {
  description = "Metadata that you can assign to help organize the frameworks you create."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "2m")
    update = optional(string, "2m")
    delete = optional(string, "2m")
  })
  default = {}
}