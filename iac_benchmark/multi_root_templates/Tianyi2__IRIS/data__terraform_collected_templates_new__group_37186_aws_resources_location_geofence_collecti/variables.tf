variable "collection_name" {
  description = "The name of the geofence collection."
  type        = string

  validation {
    condition     = length(var.collection_name) > 0
    error_message = "resource_aws_location_geofence_collection, collection_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "The optional description for the geofence collection."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "A key identifier for an AWS KMS customer managed key assigned to the Amazon Location resource."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value tags for the geofence collection."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_location_geofence_collection, timeouts must be valid duration strings (e.g., '30m', '1h', '60s')."
  }
}