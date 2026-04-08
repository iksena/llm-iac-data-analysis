variable "allocation_id" {
  description = "The ID of the Elastic IP Allocation to associate with the NAT Gateway."
  type        = string

  validation {
    condition     = can(regex("^eipalloc-[0-9a-f]{8,17}$", var.allocation_id))
    error_message = "resource_aws_nat_gateway_eip_association, allocation_id must be a valid EIP allocation ID starting with 'eipalloc-'."
  }
}

variable "nat_gateway_id" {
  description = "The ID of the NAT Gateway to associate the Elastic IP Allocation to."
  type        = string

  validation {
    condition     = can(regex("^nat-[0-9a-f]{8,17}$", var.nat_gateway_id))
    error_message = "resource_aws_nat_gateway_eip_association, nat_gateway_id must be a valid NAT Gateway ID starting with 'nat-'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_nat_gateway_eip_association, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the NAT Gateway EIP Association."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_nat_gateway_eip_association, create_timeout must be a valid timeout format (e.g., 10m, 1h, 30s)."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the NAT Gateway EIP Association."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_nat_gateway_eip_association, delete_timeout must be a valid timeout format (e.g., 10m, 1h, 30s)."
  }
}