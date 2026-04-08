variable "vpc_connection_id" {
  description = "The ID of the VPC connection."
  type        = string

  validation {
    condition     = length(var.vpc_connection_id) > 0
    error_message = "resource_aws_quicksight_vpc_connection, vpc_connection_id must not be empty."
  }
}

variable "name" {
  description = "The display name for the VPC connection."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_quicksight_vpc_connection, name must not be empty."
  }
}

variable "role_arn" {
  description = "The IAM role to associate with the VPC connection."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_quicksight_vpc_connection, role_arn must be a valid IAM role ARN."
  }
}

variable "security_group_ids" {
  description = "A list of security group IDs for the VPC connection."
  type        = list(string)

  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "resource_aws_quicksight_vpc_connection, security_group_ids must contain at least one security group ID."
  }

  validation {
    condition = alltrue([
      for sg_id in var.security_group_ids : can(regex("^sg-[0-9a-f]{8,17}$", sg_id))
    ])
    error_message = "resource_aws_quicksight_vpc_connection, security_group_ids must contain valid security group IDs (sg-xxxxxxxx format)."
  }
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the VPC connection."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_quicksight_vpc_connection, subnet_ids must contain at least one subnet ID."
  }

  validation {
    condition = alltrue([
      for subnet_id in var.subnet_ids : can(regex("^subnet-[0-9a-f]{8,17}$", subnet_id))
    ])
    error_message = "resource_aws_quicksight_vpc_connection, subnet_ids must contain valid subnet IDs (subnet-xxxxxxxx format)."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null ? true : can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_vpc_connection, aws_account_id must be a 12-digit AWS account ID."
  }
}

variable "dns_resolvers" {
  description = "A list of IP addresses of DNS resolver endpoints for the VPC connection."
  type        = list(string)
  default     = null

  validation {
    condition = var.dns_resolvers == null ? true : alltrue([
      for ip in var.dns_resolvers : can(cidrhost("${ip}/32", 0))
    ])
    error_message = "resource_aws_quicksight_vpc_connection, dns_resolvers must contain valid IP addresses."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_quicksight_vpc_connection, region must be a valid AWS region identifier."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key in keys(var.tags) : length(key) <= 128
    ])
    error_message = "resource_aws_quicksight_vpc_connection, tags keys must be 128 characters or less."
  }

  validation {
    condition = alltrue([
      for value in values(var.tags) : length(value) <= 256
    ])
    error_message = "resource_aws_quicksight_vpc_connection, tags values must be 256 characters or less."
  }
}