variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "A friendly name of the IP set"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || var.name_prefix == null
    error_message = "resource_aws_wafv2_ip_set, name and name_prefix cannot be used together"
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "description" {
  description = "A friendly description of the IP set"
  type        = string
  default     = null
}

variable "scope" {
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application"
  type        = string

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "resource_aws_wafv2_ip_set, scope must be either CLOUDFRONT or REGIONAL"
  }
}

variable "ip_address_version" {
  description = "Specify IPV4 or IPV6"
  type        = string

  validation {
    condition     = contains(["IPV4", "IPV6"], var.ip_address_version)
    error_message = "resource_aws_wafv2_ip_set, ip_address_version must be either IPV4 or IPV6"
  }
}

variable "addresses" {
  description = "Contains an array of strings that specifies zero or more IP addresses or blocks of IP addresses"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for addr in var.addresses : can(cidrhost(addr, 0))
    ])
    error_message = "resource_aws_wafv2_ip_set, addresses must be valid CIDR notation and cannot include /0"
  }

  validation {
    condition = alltrue([
      for addr in var.addresses : !endswith(addr, "/0")
    ])
    error_message = "resource_aws_wafv2_ip_set, addresses cannot include /0 CIDR ranges"
  }
}

variable "tags" {
  description = "An array of key:value pairs to associate with the resource"
  type        = map(string)
  default     = {}
}