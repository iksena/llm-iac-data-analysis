variable "core_network_id" {
  description = "ID of a core network for the VPC attachment"
  type        = string

  validation {
    condition     = length(var.core_network_id) > 0
    error_message = "resource_aws_networkmanager_vpc_attachment, core_network_id must not be empty."
  }
}

variable "subnet_arns" {
  description = "Subnet ARNs of the VPC attachment"
  type        = list(string)

  validation {
    condition     = length(var.subnet_arns) > 0
    error_message = "resource_aws_networkmanager_vpc_attachment, subnet_arns must contain at least one subnet ARN."
  }

  validation {
    condition = alltrue([
      for arn in var.subnet_arns : can(regex("^arn:aws:ec2:", arn))
    ])
    error_message = "resource_aws_networkmanager_vpc_attachment, subnet_arns must be valid AWS subnet ARNs."
  }
}

variable "vpc_arn" {
  description = "ARN of the VPC"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ec2:", var.vpc_arn))
    error_message = "resource_aws_networkmanager_vpc_attachment, vpc_arn must be a valid AWS VPC ARN."
  }
}

variable "options" {
  description = "Options for the VPC attachment"
  type = object({
    appliance_mode_support             = optional(bool)
    dns_support                        = optional(bool)
    ipv6_support                       = optional(bool)
    security_group_referencing_support = optional(bool)
  })
  default = null
}

variable "tags" {
  description = "Key-value tags for the attachment"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "15m")
    delete = optional(string, "10m")
    update = optional(string, "10m")
  })
  default = {
    create = "15m"
    delete = "10m"
    update = "10m"
  }
}