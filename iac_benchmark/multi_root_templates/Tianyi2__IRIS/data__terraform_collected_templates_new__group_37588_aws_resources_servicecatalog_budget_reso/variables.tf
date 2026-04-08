variable "budget_name" {
  description = "Budget name"
  type        = string

  validation {
    condition     = length(var.budget_name) > 0
    error_message = "resource_aws_servicecatalog_budget_resource_association, budget_name must not be empty."
  }
}

variable "resource_id" {
  description = "Resource identifier"
  type        = string

  validation {
    condition     = length(var.resource_id) > 0
    error_message = "resource_aws_servicecatalog_budget_resource_association, resource_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "3m")
    read   = optional(string, "10m")
    delete = optional(string, "3m")
  })
  default = {
    create = "3m"
    read   = "10m"
    delete = "3m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.read)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_servicecatalog_budget_resource_association, timeouts must be valid duration strings (e.g., '3m', '10m', '1h')."
  }
}