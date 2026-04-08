variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_opensearch_package_association, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "package_id" {
  description = "Internal ID of the package to associate with a domain. Forces new resource."
  type        = string

  validation {
    condition     = length(var.package_id) > 0
    error_message = "resource_aws_opensearch_package_association, package_id cannot be empty."
  }
}

variable "domain_name" {
  description = "Name of the domain to associate the package with. Forces new resource."
  type        = string

  validation {
    condition     = length(var.domain_name) > 0 && length(var.domain_name) <= 28
    error_message = "resource_aws_opensearch_package_association, domain_name must be between 1 and 28 characters."
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9\\-]+$", var.domain_name))
    error_message = "resource_aws_opensearch_package_association, domain_name must start with a lowercase letter and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    delete = "10m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create)) && can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_opensearch_package_association, timeouts must be valid duration strings (e.g., '10m', '1h')."
  }
}