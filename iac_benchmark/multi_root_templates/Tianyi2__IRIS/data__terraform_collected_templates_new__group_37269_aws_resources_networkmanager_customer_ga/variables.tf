variable "customer_gateway_arn" {
  description = "ARN of the customer gateway"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ec2:[^:]+:[^:]+:customer-gateway/cgw-[a-f0-9]+$", var.customer_gateway_arn))
    error_message = "resource_aws_networkmanager_customer_gateway_association, customer_gateway_arn must be a valid customer gateway ARN."
  }
}

variable "device_id" {
  description = "ID of the device"
  type        = string

  validation {
    condition     = length(var.device_id) > 0
    error_message = "resource_aws_networkmanager_customer_gateway_association, device_id cannot be empty."
  }
}

variable "global_network_id" {
  description = "ID of the global network"
  type        = string

  validation {
    condition     = can(regex("^global-network-[a-f0-9]+$", var.global_network_id))
    error_message = "resource_aws_networkmanager_customer_gateway_association, global_network_id must be a valid global network ID."
  }
}

variable "link_id" {
  description = "ID of the link"
  type        = string
  default     = null

  validation {
    condition     = var.link_id == null || length(var.link_id) > 0
    error_message = "resource_aws_networkmanager_customer_gateway_association, link_id cannot be empty when provided."
  }
}

variable "timeouts" {
  description = "Timeouts configuration"
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = null
}