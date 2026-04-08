variable "exportable" {
  description = "Whether the key is exportable from the service"
  type        = bool

  validation {
    condition     = can(tobool(var.exportable))
    error_message = "resource_aws_paymentcryptography_key, exportable must be a boolean value."
  }
}

variable "enabled" {
  description = "Whether to enable the key"
  type        = bool
  default     = null

  validation {
    condition     = var.enabled == null || can(tobool(var.enabled))
    error_message = "resource_aws_paymentcryptography_key, enabled must be a boolean value or null."
  }
}

variable "key_check_value_algorithm" {
  description = "Algorithm that AWS Payment Cryptography uses to calculate the key check value (KCV)"
  type        = string
  default     = null

  validation {
    condition     = var.key_check_value_algorithm == null || can(tostring(var.key_check_value_algorithm))
    error_message = "resource_aws_paymentcryptography_key, key_check_value_algorithm must be a string or null."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition     = can(tomap(var.tags))
    error_message = "resource_aws_paymentcryptography_key, tags must be a map of strings."
  }
}

variable "key_attributes" {
  description = "Role of the key, the algorithm it supports, and the cryptographic operations allowed with the key"
  type = object({
    key_algorithm = string
    key_class     = string
    key_usage     = string
    key_modes_of_use = object({
      decrypt         = optional(bool)
      derive_key      = optional(bool)
      encrypt         = optional(bool)
      generate        = optional(bool)
      no_restrictions = optional(bool)
      sign            = optional(bool)
      unwrap          = optional(bool)
      verify          = optional(bool)
      wrap            = optional(bool)
    })
  })

  validation {
    condition     = can(tostring(var.key_attributes.key_algorithm))
    error_message = "resource_aws_paymentcryptography_key, key_algorithm must be a string."
  }

  validation {
    condition     = can(tostring(var.key_attributes.key_class))
    error_message = "resource_aws_paymentcryptography_key, key_class must be a string."
  }

  validation {
    condition     = can(tostring(var.key_attributes.key_usage))
    error_message = "resource_aws_paymentcryptography_key, key_usage must be a string."
  }

  validation {
    condition = alltrue([
      for k, v in var.key_attributes.key_modes_of_use : v == null || can(tobool(v))
    ])
    error_message = "resource_aws_paymentcryptography_key, all key_modes_of_use values must be boolean or null."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.timeouts : v == null || can(regex("^[0-9]+[smh]$", v))
    ])
    error_message = "resource_aws_paymentcryptography_key, timeout values must be valid duration strings (e.g., '30m', '1h', '60s') or null."
  }
}