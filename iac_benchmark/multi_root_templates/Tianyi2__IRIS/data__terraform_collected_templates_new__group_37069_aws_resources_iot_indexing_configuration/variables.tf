variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "thing_group_indexing_configuration" {
  description = "Thing group indexing configuration"
  type = object({
    thing_group_indexing_mode = string
    custom_fields = optional(list(object({
      name = optional(string)
      type = optional(string)
    })))
    managed_fields = optional(list(object({
      name = optional(string)
      type = optional(string)
    })))
  })
  default = null

  validation {
    condition     = var.thing_group_indexing_configuration == null || contains(["OFF", "ON"], var.thing_group_indexing_configuration.thing_group_indexing_mode)
    error_message = "resource_aws_iot_indexing_configuration, thing_group_indexing_mode must be one of: OFF, ON."
  }

  validation {
    condition = var.thing_group_indexing_configuration == null || var.thing_group_indexing_configuration.custom_fields == null || alltrue([
      for field in var.thing_group_indexing_configuration.custom_fields :
      field.type == null || contains(["Number", "String", "Boolean"], field.type)
    ])
    error_message = "resource_aws_iot_indexing_configuration, custom_field type must be one of: Number, String, Boolean."
  }

  validation {
    condition = var.thing_group_indexing_configuration == null || var.thing_group_indexing_configuration.managed_fields == null || alltrue([
      for field in var.thing_group_indexing_configuration.managed_fields :
      field.type == null || contains(["Number", "String", "Boolean"], field.type)
    ])
    error_message = "resource_aws_iot_indexing_configuration, managed_field type must be one of: Number, String, Boolean."
  }
}

variable "thing_indexing_configuration" {
  description = "Thing indexing configuration"
  type = object({
    thing_indexing_mode              = string
    device_defender_indexing_mode    = optional(string, "OFF")
    named_shadow_indexing_mode       = optional(string, "OFF")
    thing_connectivity_indexing_mode = optional(string, "OFF")
    custom_fields = optional(list(object({
      name = optional(string)
      type = optional(string)
    })))
    managed_fields = optional(list(object({
      name = optional(string)
      type = optional(string)
    })))
    filter = optional(object({
      named_shadow_names = optional(list(string))
    }))
  })
  default = null

  validation {
    condition     = var.thing_indexing_configuration == null || contains(["REGISTRY", "REGISTRY_AND_SHADOW", "OFF"], var.thing_indexing_configuration.thing_indexing_mode)
    error_message = "resource_aws_iot_indexing_configuration, thing_indexing_mode must be one of: REGISTRY, REGISTRY_AND_SHADOW, OFF."
  }

  validation {
    condition     = var.thing_indexing_configuration == null || contains(["VIOLATIONS", "OFF"], var.thing_indexing_configuration.device_defender_indexing_mode)
    error_message = "resource_aws_iot_indexing_configuration, device_defender_indexing_mode must be one of: VIOLATIONS, OFF."
  }

  validation {
    condition     = var.thing_indexing_configuration == null || contains(["ON", "OFF"], var.thing_indexing_configuration.named_shadow_indexing_mode)
    error_message = "resource_aws_iot_indexing_configuration, named_shadow_indexing_mode must be one of: ON, OFF."
  }

  validation {
    condition     = var.thing_indexing_configuration == null || contains(["STATUS", "OFF"], var.thing_indexing_configuration.thing_connectivity_indexing_mode)
    error_message = "resource_aws_iot_indexing_configuration, thing_connectivity_indexing_mode must be one of: STATUS, OFF."
  }

  validation {
    condition = var.thing_indexing_configuration == null || var.thing_indexing_configuration.custom_fields == null || alltrue([
      for field in var.thing_indexing_configuration.custom_fields :
      field.type == null || contains(["Number", "String", "Boolean"], field.type)
    ])
    error_message = "resource_aws_iot_indexing_configuration, custom_field type must be one of: Number, String, Boolean."
  }

  validation {
    condition = var.thing_indexing_configuration == null || var.thing_indexing_configuration.managed_fields == null || alltrue([
      for field in var.thing_indexing_configuration.managed_fields :
      field.type == null || contains(["Number", "String", "Boolean"], field.type)
    ])
    error_message = "resource_aws_iot_indexing_configuration, managed_field type must be one of: Number, String, Boolean."
  }

  validation {
    condition     = var.thing_indexing_configuration == null || var.thing_indexing_configuration.named_shadow_indexing_mode == "OFF" || var.thing_indexing_configuration.filter != null
    error_message = "resource_aws_iot_indexing_configuration, filter is required if named_shadow_indexing_mode is ON."
  }
}