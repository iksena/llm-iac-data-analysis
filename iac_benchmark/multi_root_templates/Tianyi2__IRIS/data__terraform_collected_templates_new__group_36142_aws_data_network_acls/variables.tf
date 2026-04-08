variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID that you want to filter from."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired network ACLs."
  type        = map(string)
  default     = {}
}

variable "filter" {
  description = "Custom filter block"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_network_acls, filter: name must not be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_network_acls, filter: values must contain at least one value."
  }
}

variable "timeouts" {
  description = "Timeouts configuration"
  type = object({
    read = optional(string, "20m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      var.timeouts.read != null && can(regex("^[0-9]+(s|m|h)$", var.timeouts.read))
    )
    error_message = "data_aws_network_acls, timeouts: read timeout must be a valid duration (e.g., '20m', '1h', '30s')."
  }
}