variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the subnet group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name)) && length(var.name) > 0
    error_message = "resource_aws_dax_subnet_group, name must be a non-empty string containing only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "description" {
  description = "A description of the subnet group."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs for the subnet group."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_dax_subnet_group, subnet_ids must contain at least one subnet ID."
  }

  validation {
    condition     = alltrue([for id in var.subnet_ids : can(regex("^subnet-[a-z0-9]{8,17}$", id))])
    error_message = "resource_aws_dax_subnet_group, subnet_ids must contain valid subnet IDs in the format 'subnet-xxxxxxxxx'."
  }
}