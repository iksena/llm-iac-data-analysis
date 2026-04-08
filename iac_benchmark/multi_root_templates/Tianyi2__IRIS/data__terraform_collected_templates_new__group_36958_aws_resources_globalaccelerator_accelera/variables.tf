variable "name" {
  description = "The name of the accelerator"
  type        = string
}

variable "ip_address_type" {
  description = "The value for the address type. Valid values: IPV4, DUAL_STACK"
  type        = string
  default     = "IPV4"

  validation {
    condition     = contains(["IPV4", "DUAL_STACK"], var.ip_address_type)
    error_message = "resource_aws_globalaccelerator_accelerator, ip_address_type must be one of: IPV4, DUAL_STACK."
  }
}

variable "ip_addresses" {
  description = "The IP addresses to use for BYOIP accelerators. Valid values: 1 or 2 IPv4 addresses"
  type        = list(string)
  default     = null

  validation {
    condition     = var.ip_addresses == null || (length(var.ip_addresses) >= 1 && length(var.ip_addresses) <= 2)
    error_message = "resource_aws_globalaccelerator_accelerator, ip_addresses must contain 1 or 2 IPv4 addresses."
  }
}

variable "enabled" {
  description = "Indicates whether the accelerator is enabled. Valid values: true, false"
  type        = bool
  default     = true

  validation {
    condition     = can(regex("^(true|false)$", tostring(var.enabled)))
    error_message = "resource_aws_globalaccelerator_accelerator, enabled must be true or false."
  }
}

variable "attributes" {
  description = "The attributes of the accelerator"
  type = object({
    flow_logs_enabled   = optional(bool, false)
    flow_logs_s3_bucket = optional(string)
    flow_logs_s3_prefix = optional(string)
  })
  default = null

  validation {
    condition = var.attributes == null || (
      var.attributes.flow_logs_enabled == false ||
      (var.attributes.flow_logs_enabled == true && var.attributes.flow_logs_s3_bucket != null && var.attributes.flow_logs_s3_prefix != null)
    )
    error_message = "resource_aws_globalaccelerator_accelerator, attributes flow_logs_s3_bucket and flow_logs_s3_prefix are required when flow_logs_enabled is true."
  }

  validation {
    condition = var.attributes == null || (
      var.attributes.flow_logs_enabled == null ||
      can(regex("^(true|false)$", tostring(var.attributes.flow_logs_enabled)))
    )
    error_message = "resource_aws_globalaccelerator_accelerator, attributes flow_logs_enabled must be true or false."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
  }
}