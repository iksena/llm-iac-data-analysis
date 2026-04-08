variable "description" {
  description = "A description of the VPC endpoint association"
  type        = string
  default     = null
}

variable "firewall_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:network-firewall:", var.firewall_arn))
    error_message = "resource_aws_networkfirewall_vpc_endpoint_association, firewall_arn must be a valid Network Firewall ARN starting with 'arn:aws:network-firewall:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "subnet_mapping" {
  description = "The ID for a subnet that's used in an association with a firewall"
  type = list(object({
    ip_address_type = optional(string)
    subnet_id       = string
  }))

  validation {
    condition     = length(var.subnet_mapping) > 0
    error_message = "resource_aws_networkfirewall_vpc_endpoint_association, subnet_mapping must contain at least one subnet mapping."
  }

  validation {
    condition = alltrue([
      for mapping in var.subnet_mapping :
      mapping.ip_address_type == null || contains(["DUALSTACK", "IPV4"], mapping.ip_address_type)
    ])
    error_message = "resource_aws_networkfirewall_vpc_endpoint_association, subnet_mapping ip_address_type must be either 'DUALSTACK' or 'IPV4'."
  }

  validation {
    condition = alltrue([
      for mapping in var.subnet_mapping :
      can(regex("^subnet-", mapping.subnet_id))
    ])
    error_message = "resource_aws_networkfirewall_vpc_endpoint_association, subnet_mapping subnet_id must be a valid subnet ID starting with 'subnet-'."
  }
}

variable "tags" {
  description = "Map of resource tags to associate with the resource"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The unique identifier of the VPC for the endpoint association"
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "resource_aws_networkfirewall_vpc_endpoint_association, vpc_id must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "timeouts" {
  description = "Timeouts for the resource"
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    delete = "30m"
  }
}