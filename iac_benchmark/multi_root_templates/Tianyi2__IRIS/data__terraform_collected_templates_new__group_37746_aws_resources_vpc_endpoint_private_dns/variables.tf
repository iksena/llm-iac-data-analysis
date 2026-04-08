variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "private_dns_enabled" {
  description = "Indicates whether a private hosted zone is associated with the VPC. Only applicable for Interface endpoints."
  type        = bool

  validation {
    condition     = can(var.private_dns_enabled)
    error_message = "resource_aws_vpc_endpoint_private_dns, private_dns_enabled must be a valid boolean value."
  }
}

variable "vpc_endpoint_id" {
  description = "VPC endpoint identifier."
  type        = string

  validation {
    condition     = can(regex("^vpce-", var.vpc_endpoint_id))
    error_message = "resource_aws_vpc_endpoint_private_dns, vpc_endpoint_id must be a valid VPC endpoint ID starting with 'vpce-'."
  }
}