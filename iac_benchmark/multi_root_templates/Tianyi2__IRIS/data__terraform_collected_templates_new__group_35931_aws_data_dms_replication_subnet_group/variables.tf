variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "replication_subnet_group_id" {
  type        = string
  description = "Name for the replication subnet group. This value is stored as a lowercase string. It must contain no more than 255 alphanumeric characters, periods, spaces, underscores, or hyphens and cannot be 'default'."

  validation {
    condition     = var.replication_subnet_group_id != "default"
    error_message = "data_aws_dms_replication_subnet_group, replication_subnet_group_id cannot be 'default'."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._\\s-]+$", var.replication_subnet_group_id))
    error_message = "data_aws_dms_replication_subnet_group, replication_subnet_group_id must contain only alphanumeric characters, periods, spaces, underscores, or hyphens."
  }

  validation {
    condition     = length(var.replication_subnet_group_id) <= 255
    error_message = "data_aws_dms_replication_subnet_group, replication_subnet_group_id must contain no more than 255 characters."
  }
}