variable "name" {
  description = "The name of the worker configuration."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9\\-])*[a-zA-Z0-9]$", var.name)) && length(var.name) >= 1 && length(var.name) <= 128
    error_message = "resource_aws_mskconnect_worker_configuration, name must be between 1 and 128 characters, start and end with alphanumeric characters, and contain only alphanumeric characters and hyphens."
  }
}

variable "properties_file_content" {
  description = "Contents of connect-distributed.properties file. The value can be either base64 encoded or in raw format."
  type        = string

  validation {
    condition     = length(var.properties_file_content) > 0
    error_message = "resource_aws_mskconnect_worker_configuration, properties_file_content cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "A summary description of the worker configuration."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_mskconnect_worker_configuration, description must be 1024 characters or less."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    delete = optional(string)
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      var.timeouts.delete == null || can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    )
    error_message = "resource_aws_mskconnect_worker_configuration, timeouts delete must be in format like '10m', '1h', or '30s'."
  }
}