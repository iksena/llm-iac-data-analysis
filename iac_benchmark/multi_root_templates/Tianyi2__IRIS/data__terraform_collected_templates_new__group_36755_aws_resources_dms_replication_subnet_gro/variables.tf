variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "replication_subnet_group_description" {
  description = "Description for the subnet group."
  type        = string

  validation {
    condition     = var.replication_subnet_group_description != null && var.replication_subnet_group_description != ""
    error_message = "resource_aws_dms_replication_subnet_group, replication_subnet_group_description must be provided and cannot be empty."
  }
}

variable "replication_subnet_group_id" {
  description = "Name for the replication subnet group. This value is stored as a lowercase string. It must contain no more than 255 alphanumeric characters, periods, spaces, underscores, or hyphens and cannot be 'default'."
  type        = string

  validation {
    condition     = var.replication_subnet_group_id != null && var.replication_subnet_group_id != ""
    error_message = "resource_aws_dms_replication_subnet_group, replication_subnet_group_id must be provided and cannot be empty."
  }

  validation {
    condition     = length(var.replication_subnet_group_id) <= 255
    error_message = "resource_aws_dms_replication_subnet_group, replication_subnet_group_id must contain no more than 255 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._\\- ]+$", var.replication_subnet_group_id))
    error_message = "resource_aws_dms_replication_subnet_group, replication_subnet_group_id must contain only alphanumeric characters, periods, spaces, underscores, or hyphens."
  }

  validation {
    condition     = var.replication_subnet_group_id != "default"
    error_message = "resource_aws_dms_replication_subnet_group, replication_subnet_group_id cannot be 'default'."
  }
}

variable "subnet_ids" {
  description = "List of at least 2 EC2 subnet IDs for the subnet group. The subnets must cover at least 2 availability zones."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "resource_aws_dms_replication_subnet_group, subnet_ids must contain at least 2 subnet IDs."
  }

  validation {
    condition = alltrue([
      for subnet_id in var.subnet_ids : can(regex("^subnet-[a-z0-9]+$", subnet_id))
    ])
    error_message = "resource_aws_dms_replication_subnet_group, subnet_ids must contain valid subnet IDs in format 'subnet-xxxxxxxxx'."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

