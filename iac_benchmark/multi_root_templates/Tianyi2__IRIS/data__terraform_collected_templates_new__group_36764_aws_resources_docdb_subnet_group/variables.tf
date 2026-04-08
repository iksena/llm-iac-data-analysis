variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the docDB subnet group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "resource_aws_docdb_subnet_group, name must contain only alphanumeric characters and hyphens."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-zA-Z0-9-]+$", var.name_prefix))
    error_message = "resource_aws_docdb_subnet_group, name_prefix must contain only alphanumeric characters and hyphens."
  }
}

variable "description" {
  description = "The description of the docDB subnet group. Defaults to 'Managed by Terraform'."
  type        = string
  default     = "Managed by Terraform"
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_docdb_subnet_group, subnet_ids must contain at least one subnet ID."
  }

  validation {
    condition     = alltrue([for id in var.subnet_ids : can(regex("^subnet-[a-f0-9]{8}([a-f0-9]{9})?$", id))])
    error_message = "resource_aws_docdb_subnet_group, subnet_ids must be valid subnet IDs starting with 'subnet-'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}