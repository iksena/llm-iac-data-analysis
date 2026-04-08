variable "environment_id" {
  description = "Unique identifier for the KX environment"
  type        = string

  validation {
    condition     = length(var.environment_id) > 0
    error_message = "resource_aws_finspace_kx_database, environment_id must not be empty."
  }
}

variable "name" {
  description = "Name of the KX database"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_finspace_kx_database, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the KX database"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
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
}