variable "name" {
  description = "Name for the sink."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name)) && length(var.name) > 0
    error_message = "resource_aws_oam_sink, name must be a non-empty string containing only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_oam_sink, region must be a valid AWS region identifier or null."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_oam_sink, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}

variable "timeouts" {
  description = "Configuration options for resource operation timeouts."
  type = object({
    create = optional(string, "1m")
    update = optional(string, "1m")
    delete = optional(string, "1m")
  })
  default = {
    create = "1m"
    update = "1m"
    delete = "1m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_oam_sink, timeouts must be valid duration strings (e.g., '1m', '30s', '1h')."
  }
}