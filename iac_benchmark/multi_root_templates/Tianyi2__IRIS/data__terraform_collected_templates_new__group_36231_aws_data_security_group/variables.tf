variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filter" {
  description = "Custom filter block as described below."
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = null

  validation {
    condition = var.filter == null ? true : alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_security_group, filter: name is required and cannot be empty."
  }

  validation {
    condition = var.filter == null ? true : alltrue([
      for f in var.filter : f.values != null && length(f.values) > 0
    ])
    error_message = "data_aws_security_group, filter: values is required and cannot be empty."
  }
}

variable "id" {
  description = "Id of the specific security group to retrieve."
  type        = string
  default     = null

  validation {
    condition     = var.id == null || can(regex("^sg-[0-9a-f]{8,17}$", var.id))
    error_message = "data_aws_security_group, id: must be a valid security group ID format (sg-xxxxxxxx)."
  }
}

variable "name" {
  description = "Name that the desired security group must have."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "data_aws_security_group, name: cannot be empty if specified."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired security group."
  type        = map(string)
  default     = null
}

variable "vpc_id" {
  description = "Id of the VPC that the desired security group belongs to."
  type        = string
  default     = null

  validation {
    condition     = var.vpc_id == null || can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "data_aws_security_group, vpc_id: must be a valid VPC ID format (vpc-xxxxxxxx)."
  }
}

variable "timeouts_read" {
  description = "Read timeout configuration"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[ms]$", var.timeouts_read))
    error_message = "data_aws_security_group, timeouts_read: must be a valid timeout format (e.g., '20m', '30s')."
  }
}