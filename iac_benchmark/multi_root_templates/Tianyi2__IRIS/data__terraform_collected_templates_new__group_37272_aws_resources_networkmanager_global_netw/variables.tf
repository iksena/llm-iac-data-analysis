variable "description" {
  description = "Description of the Global Network"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || can(regex("^.{0,256}$", var.description))
    error_message = "resource_aws_networkmanager_global_network, description must be 256 characters or less."
  }
}

variable "tags" {
  description = "Key-value tags for the Global Network"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_networkmanager_global_network, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_networkmanager_global_network, tags values must be 256 characters or less."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the Global Network"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_networkmanager_global_network, create_timeout must be a valid duration (e.g., 10m, 1h)."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the Global Network"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_networkmanager_global_network, delete_timeout must be a valid duration (e.g., 10m, 1h)."
  }
}

variable "update_timeout" {
  description = "Timeout for updating the Global Network"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.update_timeout))
    error_message = "resource_aws_networkmanager_global_network, update_timeout must be a valid duration (e.g., 10m, 1h)."
  }
}