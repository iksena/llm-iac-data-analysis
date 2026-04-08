variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the VPC Link. Must be between 1 and 128 characters in length."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 128
    error_message = "resource_aws_apigatewayv2_vpc_link, name must be between 1 and 128 characters in length."
  }
}

variable "security_group_ids" {
  description = "Security group IDs for the VPC Link."
  type        = list(string)

  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "resource_aws_apigatewayv2_vpc_link, security_group_ids must contain at least one security group ID."
  }
}

variable "subnet_ids" {
  description = "Subnet IDs for the VPC Link."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_apigatewayv2_vpc_link, subnet_ids must contain at least one subnet ID."
  }
}

variable "tags" {
  description = "Map of tags to assign to the VPC Link."
  type        = map(string)
  default     = {}
}