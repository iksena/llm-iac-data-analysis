variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "resource_aws_connect_user_hierarchy_structure, instance_id must be a valid UUID format (aaaaaaaa-bbbb-cccc-dddd-111111111111)."
  }
}

variable "hierarchy_structure" {
  description = "A block that defines the hierarchy structure's levels."
  type = object({
    level_one = optional(object({
      name = string
    }))
    level_two = optional(object({
      name = string
    }))
    level_three = optional(object({
      name = string
    }))
    level_four = optional(object({
      name = string
    }))
    level_five = optional(object({
      name = string
    }))
  })

  validation {
    condition     = var.hierarchy_structure.level_one != null ? length(var.hierarchy_structure.level_one.name) <= 50 : true
    error_message = "resource_aws_connect_user_hierarchy_structure, level_one.name must not be more than 50 characters."
  }

  validation {
    condition     = var.hierarchy_structure.level_two != null ? length(var.hierarchy_structure.level_two.name) <= 50 : true
    error_message = "resource_aws_connect_user_hierarchy_structure, level_two.name must not be more than 50 characters."
  }

  validation {
    condition     = var.hierarchy_structure.level_three != null ? length(var.hierarchy_structure.level_three.name) <= 50 : true
    error_message = "resource_aws_connect_user_hierarchy_structure, level_three.name must not be more than 50 characters."
  }

  validation {
    condition     = var.hierarchy_structure.level_four != null ? length(var.hierarchy_structure.level_four.name) <= 50 : true
    error_message = "resource_aws_connect_user_hierarchy_structure, level_four.name must not be more than 50 characters."
  }

  validation {
    condition     = var.hierarchy_structure.level_five != null ? length(var.hierarchy_structure.level_five.name) <= 50 : true
    error_message = "resource_aws_connect_user_hierarchy_structure, level_five.name must not be more than 50 characters."
  }

  validation {
    condition     = var.hierarchy_structure.level_one != null ? var.hierarchy_structure.level_one.name != "" : true
    error_message = "resource_aws_connect_user_hierarchy_structure, level_one.name is required when level_one is specified."
  }

  validation {
    condition     = var.hierarchy_structure.level_two != null ? var.hierarchy_structure.level_two.name != "" : true
    error_message = "resource_aws_connect_user_hierarchy_structure, level_two.name is required when level_two is specified."
  }

  validation {
    condition     = var.hierarchy_structure.level_three != null ? var.hierarchy_structure.level_three.name != "" : true
    error_message = "resource_aws_connect_user_hierarchy_structure, level_three.name is required when level_three is specified."
  }

  validation {
    condition     = var.hierarchy_structure.level_four != null ? var.hierarchy_structure.level_four.name != "" : true
    error_message = "resource_aws_connect_user_hierarchy_structure, level_four.name is required when level_four is specified."
  }

  validation {
    condition     = var.hierarchy_structure.level_five != null ? var.hierarchy_structure.level_five.name != "" : true
    error_message = "resource_aws_connect_user_hierarchy_structure, level_five.name is required when level_five is specified."
  }
}