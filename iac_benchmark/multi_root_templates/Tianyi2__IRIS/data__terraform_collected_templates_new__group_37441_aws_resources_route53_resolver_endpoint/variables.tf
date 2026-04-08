variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "direction" {
  description = "Direction of DNS queries to or from the Route 53 Resolver endpoint."
  type        = string

  validation {
    condition     = contains(["INBOUND", "OUTBOUND", "INBOUND_DELEGATION"], var.direction)
    error_message = "resource_aws_route53_resolver_endpoint, direction must be one of: INBOUND, OUTBOUND, INBOUND_DELEGATION."
  }
}

variable "ip_addresses" {
  description = "Subnets and IP addresses in your VPC that you want DNS queries to pass through."
  type = list(object({
    ip        = optional(string)
    ipv6      = optional(string)
    subnet_id = string
  }))

  validation {
    condition     = length(var.ip_addresses) > 0
    error_message = "resource_aws_route53_resolver_endpoint, ip_addresses must contain at least one IP address configuration."
  }
}

variable "name" {
  description = "Friendly name of the Route 53 Resolver endpoint."
  type        = string
  default     = null
}

variable "protocols" {
  description = "Protocols you want to use for the Route 53 Resolver endpoint."
  type        = list(string)
  default     = null

  validation {
    condition = var.protocols == null ? true : alltrue([
      for protocol in var.protocols : contains(["DoH", "Do53", "DoH-FIPS"], protocol)
    ])
    error_message = "resource_aws_route53_resolver_endpoint, protocols must only contain values: DoH, Do53, DoH-FIPS."
  }
}

variable "resolver_endpoint_type" {
  description = "Endpoint IP type. This endpoint type is applied to all IP addresses."
  type        = string
  default     = null

  validation {
    condition     = var.resolver_endpoint_type == null ? true : contains(["IPV6", "IPV4", "DUALSTACK"], var.resolver_endpoint_type)
    error_message = "resource_aws_route53_resolver_endpoint, resolver_endpoint_type must be one of: IPV6, IPV4, DUALSTACK."
  }
}

variable "security_group_ids" {
  description = "ID of one or more security groups that you want to use to control access to this VPC."
  type        = list(string)

  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "resource_aws_route53_resolver_endpoint, security_group_ids must contain at least one security group ID."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for create operation."
  type        = string
  default     = "10m"
}

variable "update_timeout" {
  description = "Timeout for update operation."
  type        = string
  default     = "10m"
}

variable "delete_timeout" {
  description = "Timeout for delete operation."
  type        = string
  default     = "10m"
}