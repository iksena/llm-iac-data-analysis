variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_scheduler_schedule_group, region must be a valid AWS region format."
  }
}

variable "name" {
  description = "Name of the schedule group"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) <= 64
    error_message = "resource_aws_scheduler_schedule_group, name must be 64 characters or less."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || length(var.name_prefix) <= 64
    error_message = "resource_aws_scheduler_schedule_group, name_prefix must be 64 characters or less."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_scheduler_schedule_group, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_scheduler_schedule_group, tags values must be between 0 and 256 characters."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string)
    delete = optional(string)
  })
  default = null

  validation {
    condition = var.timeouts == null || alltrue([
      var.timeouts.create == null || can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      var.timeouts.delete == null || can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_scheduler_schedule_group, timeouts must be valid duration strings (e.g., '5m', '30s', '2h')."
  }
}