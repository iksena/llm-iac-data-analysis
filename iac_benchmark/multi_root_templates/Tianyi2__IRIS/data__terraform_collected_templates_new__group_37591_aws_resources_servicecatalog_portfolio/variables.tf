variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the portfolio."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_servicecatalog_portfolio, name must not be empty."
  }
}

variable "description" {
  description = "Description of the portfolio"
  type        = string

  validation {
    condition     = length(var.description) > 0
    error_message = "resource_aws_servicecatalog_portfolio, description must not be empty."
  }
}

variable "provider_name" {
  description = "Name of the person or organization who owns the portfolio."
  type        = string

  validation {
    condition     = length(var.provider_name) > 0
    error_message = "resource_aws_servicecatalog_portfolio, provider_name must not be empty."
  }
}

variable "tags" {
  description = "Tags to apply to the connection. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Timeout for create operation"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_servicecatalog_portfolio, timeouts_create must be a valid duration format (e.g., 30m, 1h)."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operation"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "resource_aws_servicecatalog_portfolio, timeouts_read must be a valid duration format (e.g., 10m, 1h)."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operation"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_servicecatalog_portfolio, timeouts_update must be a valid duration format (e.g., 30m, 1h)."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operation"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_servicecatalog_portfolio, timeouts_delete must be a valid duration format (e.g., 30m, 1h)."
  }
}