variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name or description of the IPSet."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_wafregional_ipset, name must not be empty."
  }
}

variable "ip_set_descriptor" {
  description = "One or more pairs specifying the IP address type (IPV4 or IPV6) and the IP address range (in CIDR notation) from which web requests originate."
  type = list(object({
    type  = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for descriptor in var.ip_set_descriptor :
      contains(["IPV4", "IPV6"], descriptor.type)
    ])
    error_message = "resource_aws_wafregional_ipset, ip_set_descriptor type must be either 'IPV4' or 'IPV6'."
  }

  validation {
    condition = alltrue([
      for descriptor in var.ip_set_descriptor :
      can(cidrhost(descriptor.value, 0))
    ])
    error_message = "resource_aws_wafregional_ipset, ip_set_descriptor value must be a valid CIDR notation."
  }
}