variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "address_family" {
  description = "Address family (IPv4 or IPv6) of this prefix list."
  type        = string

  validation {
    condition     = contains(["IPv4", "IPv6"], var.address_family)
    error_message = "resource_aws_ec2_managed_prefix_list, address_family must be either 'IPv4' or 'IPv6'."
  }
}

variable "entry" {
  description = "Configuration block for prefix list entry. Different entries may have overlapping CIDR blocks, but a particular CIDR should not be duplicated."
  type = list(object({
    cidr        = string
    description = optional(string)
  }))
  default = null
}

variable "max_entries" {
  description = "Maximum number of entries that this prefix list can contain."
  type        = number

  validation {
    condition     = var.max_entries > 0
    error_message = "resource_aws_ec2_managed_prefix_list, max_entries must be greater than 0."
  }
}

variable "name" {
  description = "Name of this resource. The name must not start with com.amazonaws."
  type        = string

  validation {
    condition     = !startswith(var.name, "com.amazonaws")
    error_message = "resource_aws_ec2_managed_prefix_list, name must not start with 'com.amazonaws'."
  }
}

variable "tags" {
  description = "Map of tags to assign to this resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}