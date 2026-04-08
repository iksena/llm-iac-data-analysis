variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filter" {
  description = "One or more configuration blocks containing name-values filters."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_transit_gateway_multicast_domain, filter: name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_multicast_domain, filter: values is required and must contain at least one value."
  }

  validation {
    condition = alltrue([
      for f in var.filter : alltrue([
        for v in f.values : v != null && v != ""
      ])
    ])
    error_message = "data_aws_ec2_transit_gateway_multicast_domain, filter: values cannot contain null or empty strings."
  }
}

variable "transit_gateway_multicast_domain_id" {
  description = "Identifier of the EC2 Transit Gateway Multicast Domain."
  type        = string
  default     = null

  validation {
    condition     = var.transit_gateway_multicast_domain_id == null || can(regex("^tgw-mcast-domain-[0-9a-f]{8,17}$", var.transit_gateway_multicast_domain_id))
    error_message = "data_aws_ec2_transit_gateway_multicast_domain, transit_gateway_multicast_domain_id: must be a valid transit gateway multicast domain ID (tgw-mcast-domain-xxxxxxxx)."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_ec2_transit_gateway_multicast_domain, timeouts_read: must be a valid timeout format (e.g., 20m, 1h, 30s)."
  }
}