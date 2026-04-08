variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the thing type."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9:_-]+$", var.name))
    error_message = "resource_aws_iot_thing_type, name must contain only alphanumeric characters, colons, underscores, and hyphens."
  }
}

variable "deprecated" {
  description = "Whether the thing type is deprecated. If true, no new things could be associated with this type."
  type        = bool
  default     = false
}

variable "properties" {
  description = "Configuration block that can contain the following properties of the thing type."
  type = object({
    description           = optional(string)
    searchable_attributes = optional(list(string))
  })
  default = null

  validation {
    condition = var.properties == null || (
      var.properties.searchable_attributes == null ||
      alltrue([for attr in var.properties.searchable_attributes : can(regex("^[a-zA-Z0-9_-]+$", attr))])
    )
    error_message = "resource_aws_iot_thing_type, searchable_attributes must contain only alphanumeric characters, underscores, and hyphens."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key in keys(var.tags) : can(regex("^[a-zA-Z0-9\\s._:/=+@-]{1,128}$", key))
    ])
    error_message = "resource_aws_iot_thing_type, tags keys must be 1-128 characters and contain only alphanumeric characters, spaces, and the following characters: . _ : / = + @ -"
  }

  validation {
    condition = alltrue([
      for value in values(var.tags) : can(regex("^[a-zA-Z0-9\\s._:/=+@-]{0,256}$", value))
    ])
    error_message = "resource_aws_iot_thing_type, tags values must be 0-256 characters and contain only alphanumeric characters, spaces, and the following characters: . _ : / = + @ -"
  }
}