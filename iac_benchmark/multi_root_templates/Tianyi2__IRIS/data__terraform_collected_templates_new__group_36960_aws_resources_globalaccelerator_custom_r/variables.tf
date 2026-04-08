variable "name" {
  description = "The name of a custom routing accelerator."
  type        = string
}

variable "ip_address_type" {
  description = "The IP address type that an accelerator supports. For a custom routing accelerator, the value must be IPV4."
  type        = string
  default     = "IPV4"

  validation {
    condition     = var.ip_address_type == "IPV4"
    error_message = "resource_aws_globalaccelerator_custom_routing_accelerator, ip_address_type must be 'IPV4'."
  }
}

variable "ip_addresses" {
  description = "The IP addresses to use for BYOIP accelerators. If not specified, the service assigns IP addresses. Valid values: 1 or 2 IPv4 addresses."
  type        = list(string)
  default     = null

  validation {
    condition     = var.ip_addresses == null ? true : length(var.ip_addresses) >= 1 && length(var.ip_addresses) <= 2
    error_message = "resource_aws_globalaccelerator_custom_routing_accelerator, ip_addresses must contain 1 or 2 IPv4 addresses."
  }

  validation {
    condition = var.ip_addresses == null ? true : alltrue([
      for ip in var.ip_addresses : can(cidrhost("${ip}/32", 0))
    ])
    error_message = "resource_aws_globalaccelerator_custom_routing_accelerator, ip_addresses must contain valid IPv4 addresses."
  }
}

variable "enabled" {
  description = "Indicates whether the accelerator is enabled. Defaults to true. Valid values: true, false."
  type        = bool
  default     = true
}

variable "attributes" {
  description = "The attributes of the accelerator."
  type = object({
    flow_logs_enabled   = optional(bool, false)
    flow_logs_s3_bucket = optional(string)
    flow_logs_s3_prefix = optional(string)
  })
  default = null

  validation {
    condition = var.attributes == null ? true : (
      var.attributes.flow_logs_enabled == true ? (
        var.attributes.flow_logs_s3_bucket != null && var.attributes.flow_logs_s3_prefix != null
      ) : true
    )
    error_message = "resource_aws_globalaccelerator_custom_routing_accelerator, attributes flow_logs_s3_bucket and flow_logs_s3_prefix are required when flow_logs_enabled is true."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Timeouts for resource operations."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
  }
}