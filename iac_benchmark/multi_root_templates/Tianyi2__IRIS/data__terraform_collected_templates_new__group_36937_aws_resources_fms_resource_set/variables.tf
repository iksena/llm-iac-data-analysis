variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_set" {
  description = "Details about the resource set to be created or updated."
  type = object({
    name                = string
    resource_type_list  = list(string)
    description         = optional(string)
    last_update_time    = optional(string)
    resource_set_status = optional(string)
  })

  validation {
    condition     = can(regex("^.+$", var.resource_set.name))
    error_message = "resource_aws_fms_resource_set, name must be a non-empty string."
  }

  validation {
    condition     = length(var.resource_set.resource_type_list) > 0
    error_message = "resource_aws_fms_resource_set, resource_type_list must contain at least one resource type."
  }

  validation {
    condition     = var.resource_set.resource_set_status == null || can(regex("^(ACTIVE|OUT_OF_ADMIN_SCOPE)$", var.resource_set.resource_set_status))
    error_message = "resource_aws_fms_resource_set, resource_set_status must be either 'ACTIVE' or 'OUT_OF_ADMIN_SCOPE'."
  }
}

variable "timeouts" {
  description = "Timeout configurations for resource operations."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts.create))
    error_message = "resource_aws_fms_resource_set, create must be a valid timeout format (e.g., '30m', '1h', '120s')."
  }

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts.update))
    error_message = "resource_aws_fms_resource_set, update must be a valid timeout format (e.g., '30m', '1h', '120s')."
  }

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts.delete))
    error_message = "resource_aws_fms_resource_set, delete must be a valid timeout format (e.g., '30m', '1h', '120s')."
  }
}