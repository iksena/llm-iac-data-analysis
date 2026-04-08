variable "name" {
  description = "Name of the resource gateway."
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the VPC subnets in which to create the resource gateway."
  type        = list(string)
  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_vpclattice_resource_gateway, subnet_ids must contain at least one subnet ID."
  }
}

variable "vpc_id" {
  description = "ID of the VPC for the resource gateway."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "ip_address_type" {
  description = "IP address type used by the resource gateway. Valid values are IPV4, IPV6, and DUALSTACK."
  type        = string
  default     = null
  validation {
    condition     = var.ip_address_type == null || contains(["IPV4", "IPV6", "DUALSTACK"], var.ip_address_type)
    error_message = "resource_aws_vpclattice_resource_gateway, ip_address_type must be one of: IPV4, IPV6, DUALSTACK."
  }
}

variable "security_group_ids" {
  description = "Security group IDs associated with the resource gateway. The security groups must be in the same VPC."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  type        = map(string)
  default     = {}
}