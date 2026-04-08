variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_connector_name" {
  description = "Name for the VPC connector."
  type        = string

  validation {
    condition     = length(var.vpc_connector_name) > 0
    error_message = "resource_aws_apprunner_vpc_connector, vpc_connector_name must not be empty."
  }
}

variable "subnets" {
  description = "List of IDs of subnets that App Runner should use when it associates your service with a custom Amazon VPC. Specify IDs of subnets of a single Amazon VPC. App Runner determines the Amazon VPC from the subnets you specify."
  type        = list(string)

  validation {
    condition     = length(var.subnets) > 0
    error_message = "resource_aws_apprunner_vpc_connector, subnets must contain at least one subnet ID."
  }

  validation {
    condition = alltrue([
      for subnet in var.subnets : can(regex("^subnet-[a-z0-9]+$", subnet))
    ])
    error_message = "resource_aws_apprunner_vpc_connector, subnets must be valid subnet IDs starting with 'subnet-'."
  }
}

variable "security_groups" {
  description = "List of IDs of security groups that App Runner should use for access to AWS resources under the specified subnets. If not specified, App Runner uses the default security group of the Amazon VPC. The default security group allows all outbound traffic."
  type        = list(string)
  default     = null

  validation {
    condition = var.security_groups == null ? true : alltrue([
      for sg in var.security_groups : can(regex("^sg-[a-z0-9]+$", sg))
    ])
    error_message = "resource_aws_apprunner_vpc_connector, security_groups must be valid security group IDs starting with 'sg-'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}