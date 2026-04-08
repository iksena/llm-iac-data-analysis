variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_instances, region must be a valid AWS region identifier or null."
  }
}

variable "instance_tags" {
  description = "Map of tags, each pair of which must exactly match a pair on desired instances."
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.instance_tags) >= 0
    error_message = "data_aws_instances, instance_tags must be a valid map of strings."
  }
}

variable "instance_state_names" {
  description = "List of instance states that should be applicable to the desired instances. The permitted values are: pending, running, shutting-down, stopped, stopping, terminated. The default value is running."
  type        = list(string)
  default     = ["running"]

  validation {
    condition = alltrue([
      for state in var.instance_state_names :
      contains(["pending", "running", "shutting-down", "stopped", "stopping", "terminated"], state)
    ])
    error_message = "data_aws_instances, instance_state_names must contain only valid instance states: pending, running, shutting-down, stopped, stopping, terminated."
  }
}

variable "filters" {
  description = "One or more name/value pairs to use as filters for describe-instances."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filters :
      filter.name != null && length(filter.values) > 0
    ])
    error_message = "data_aws_instances, filters must have non-null name and non-empty values list."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    read = optional(string, "20m")
  })
  default = null

  validation {
    condition     = var.timeouts == null || can(regex("^[0-9]+[smh]$", var.timeouts.read))
    error_message = "data_aws_instances, timeouts read must be a valid duration string (e.g., '20m', '1h') or null."
  }
}