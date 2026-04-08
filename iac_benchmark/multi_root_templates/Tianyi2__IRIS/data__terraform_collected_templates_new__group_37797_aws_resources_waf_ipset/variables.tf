variable "name" {
  description = "The name or description of the IPSet"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_waf_ipset, name must not be empty."
  }
}

variable "ip_set_descriptors" {
  description = "One or more pairs specifying the IP address type (IPV4 or IPV6) and the IP address range (in CIDR format) from which web requests originate"
  type = list(object({
    type  = string
    value = string
  }))
  default = null

  validation {
    condition = var.ip_set_descriptors == null ? true : alltrue([
      for descriptor in var.ip_set_descriptors : contains(["IPV4", "IPV6"], descriptor.type)
    ])
    error_message = "resource_aws_waf_ipset, ip_set_descriptors type must be either 'IPV4' or 'IPV6'."
  }

  validation {
    condition = var.ip_set_descriptors == null ? true : alltrue([
      for descriptor in var.ip_set_descriptors : can(cidrhost(descriptor.value, 0))
    ])
    error_message = "resource_aws_waf_ipset, ip_set_descriptors value must be a valid CIDR notation."
  }
}