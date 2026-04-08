variable "security_group_ids" {
  description = "One or more security groups used to control access from streaming instances to your VPC"
  type        = list(string)

  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "resource_aws_workspacesweb_network_settings, security_group_ids must contain at least one security group ID."
  }
}

variable "subnet_ids" {
  description = "The subnets in which network interfaces are created to connect streaming instances to your VPC. At least two subnet ids must be specified"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "resource_aws_workspacesweb_network_settings, subnet_ids must contain at least two subnet IDs."
  }
}

variable "vpc_id" {
  description = "The VPC that streaming instances will connect to"
  type        = string

  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "resource_aws_workspacesweb_network_settings, vpc_id cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags assigned to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}
}