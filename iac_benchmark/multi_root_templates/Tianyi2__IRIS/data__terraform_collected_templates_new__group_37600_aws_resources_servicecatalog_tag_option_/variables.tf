variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_servicecatalog_tag_option_resource_association, region must be a valid AWS region identifier or null."
  }
}

variable "resource_id" {
  description = "Resource identifier."
  type        = string

  validation {
    condition     = length(var.resource_id) > 0
    error_message = "resource_aws_servicecatalog_tag_option_resource_association, resource_id cannot be empty."
  }
}

variable "tag_option_id" {
  description = "Tag Option identifier."
  type        = string

  validation {
    condition     = length(var.tag_option_id) > 0
    error_message = "resource_aws_servicecatalog_tag_option_resource_association, tag_option_id cannot be empty."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "3m")
    read   = optional(string, "10m")
    delete = optional(string, "3m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      can(regex("^[0-9]+[smh]$", var.timeouts.create)) &&
      can(regex("^[0-9]+[smh]$", var.timeouts.read)) &&
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    )
    error_message = "resource_aws_servicecatalog_tag_option_resource_association, timeouts must be valid duration strings (e.g., '3m', '10s', '1h')."
  }
}