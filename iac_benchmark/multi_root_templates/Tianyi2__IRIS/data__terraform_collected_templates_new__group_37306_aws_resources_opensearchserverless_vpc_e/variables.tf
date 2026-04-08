variable "name" {
  description = "Name of the interface endpoint."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.name))
    error_message = "resource_aws_opensearchserverless_vpc_endpoint, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "subnet_ids" {
  description = "One or more subnet IDs from which you'll access OpenSearch Serverless. Up to 6 subnets can be provided."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0 && length(var.subnet_ids) <= 6
    error_message = "resource_aws_opensearchserverless_vpc_endpoint, subnet_ids must contain between 1 and 6 subnet IDs."
  }

  validation {
    condition = alltrue([
      for subnet_id in var.subnet_ids : can(regex("^subnet-[a-z0-9]{8,17}$", subnet_id))
    ])
    error_message = "resource_aws_opensearchserverless_vpc_endpoint, subnet_ids must be valid subnet ID format (subnet-xxxxxxxx)."
  }
}

variable "vpc_id" {
  description = "ID of the VPC from which you'll access OpenSearch Serverless."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]{8,17}$", var.vpc_id))
    error_message = "resource_aws_opensearchserverless_vpc_endpoint, vpc_id must be a valid VPC ID format (vpc-xxxxxxxx)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_opensearchserverless_vpc_endpoint, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "security_group_ids" {
  description = "One or more security groups that define the ports, protocols, and sources for inbound traffic that you are authorizing into your endpoint. Up to 5 security groups can be provided."
  type        = list(string)
  default     = null

  validation {
    condition = var.security_group_ids == null ? true : (
      length(var.security_group_ids) <= 5 && length(var.security_group_ids) > 0
    )
    error_message = "resource_aws_opensearchserverless_vpc_endpoint, security_group_ids must contain between 1 and 5 security group IDs when specified."
  }

  validation {
    condition = var.security_group_ids == null ? true : alltrue([
      for sg_id in var.security_group_ids : can(regex("^sg-[a-z0-9]{8,17}$", sg_id))
    ])
    error_message = "resource_aws_opensearchserverless_vpc_endpoint, security_group_ids must be valid security group ID format (sg-xxxxxxxx)."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operation."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_create))
    error_message = "resource_aws_opensearchserverless_vpc_endpoint, timeouts_create must be a valid duration (e.g., 30m, 1h)."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operation."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_update))
    error_message = "resource_aws_opensearchserverless_vpc_endpoint, timeouts_update must be a valid duration (e.g., 30m, 1h)."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operation."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_delete))
    error_message = "resource_aws_opensearchserverless_vpc_endpoint, timeouts_delete must be a valid duration (e.g., 30m, 1h)."
  }
}