variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "allocation_id" {
  description = "The allocation ID."
  type        = string

  validation {
    condition     = can(regex("^eipalloc-[a-z0-9]+$", var.allocation_id))
    error_message = "resource_aws_eip_domain_name, allocation_id must be a valid EIP allocation ID starting with 'eipalloc-'."
  }
}

variable "domain_name" {
  description = "The domain name to modify for the IP address."
  type        = string

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "resource_aws_eip_domain_name, domain_name cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9\\-\\.]*[a-zA-Z0-9]$", var.domain_name))
    error_message = "resource_aws_eip_domain_name, domain_name must be a valid domain name."
  }
}

variable "timeouts" {
  description = "Configuration options for operation timeouts."
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  validation {
    condition     = can(regex("^\\d+[smh]$", var.timeouts.create)) && can(regex("^\\d+[smh]$", var.timeouts.update)) && can(regex("^\\d+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_eip_domain_name, timeouts must be valid duration strings (e.g., '10m', '1h', '30s')."
  }
}