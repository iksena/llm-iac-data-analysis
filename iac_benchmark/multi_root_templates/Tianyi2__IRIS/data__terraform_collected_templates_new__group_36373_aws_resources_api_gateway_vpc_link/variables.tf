variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name used to label and identify the VPC link."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_api_gateway_vpc_link, name must not be empty."
  }
}

variable "description" {
  description = "Description of the VPC link."
  type        = string
  default     = null
}

variable "target_arns" {
  description = "List of network load balancer arns in the VPC targeted by the VPC link. Currently AWS only supports 1 target."
  type        = list(string)

  validation {
    condition     = length(var.target_arns) > 0
    error_message = "resource_aws_api_gateway_vpc_link, target_arns must contain at least one ARN."
  }

  validation {
    condition     = length(var.target_arns) == 1
    error_message = "resource_aws_api_gateway_vpc_link, target_arns currently AWS only supports 1 target."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}