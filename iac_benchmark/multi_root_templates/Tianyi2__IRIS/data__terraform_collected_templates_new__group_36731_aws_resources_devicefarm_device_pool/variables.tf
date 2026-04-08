variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the Device Pool"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_devicefarm_device_pool, name must not be empty."
  }
}

variable "project_arn" {
  description = "The ARN of the project for the device pool."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:devicefarm:", var.project_arn))
    error_message = "resource_aws_devicefarm_device_pool, project_arn must be a valid Device Farm project ARN."
  }
}

variable "rule" {
  description = "The device pool's rules."
  type = list(object({
    attribute = optional(string)
    operator  = optional(string)
    value     = optional(string)
  }))

  validation {
    condition = alltrue([
      for rule in var.rule : rule.attribute == null || contains([
        "APPIUM_VERSION", "ARN", "AVAILABILITY", "FLEET_TYPE", "FORM_FACTOR",
        "INSTANCE_ARN", "INSTANCE_LABELS", "MANUFACTURER", "MODEL", "OS_VERSION",
        "PLATFORM", "REMOTE_ACCESS_ENABLED", "REMOTE_DEBUG_ENABLED"
      ], rule.attribute)
    ])
    error_message = "resource_aws_devicefarm_device_pool, rule attribute must be one of: APPIUM_VERSION, ARN, AVAILABILITY, FLEET_TYPE, FORM_FACTOR, INSTANCE_ARN, INSTANCE_LABELS, MANUFACTURER, MODEL, OS_VERSION, PLATFORM, REMOTE_ACCESS_ENABLED, REMOTE_DEBUG_ENABLED."
  }

  validation {
    condition = alltrue([
      for rule in var.rule : rule.operator == null || contains([
        "EQUALS", "NOT_IN", "IN", "GREATER_THAN", "GREATER_THAN_OR_EQUALS",
        "LESS_THAN", "LESS_THAN_OR_EQUALS", "CONTAINS"
      ], rule.operator)
    ])
    error_message = "resource_aws_devicefarm_device_pool, rule operator must be one of: EQUALS, NOT_IN, IN, GREATER_THAN, GREATER_THAN_OR_EQUALS, LESS_THAN, LESS_THAN_OR_EQUALS, CONTAINS."
  }
}

variable "description" {
  description = "The device pool's description."
  type        = string
  default     = null
}

variable "max_devices" {
  description = "The number of devices that Device Farm can add to your device pool."
  type        = number
  default     = null

  validation {
    condition     = var.max_devices == null || var.max_devices > 0
    error_message = "resource_aws_devicefarm_device_pool, max_devices must be greater than 0 when specified."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}