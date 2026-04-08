variable "subnet_ids" {
  description = "Set of VPC Subnet ID-s for the subnet group. At least one subnet must be provided."
  type        = set(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_memorydb_subnet_group, subnet_ids must contain at least one subnet ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the subnet group. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || var.name_prefix == null
    error_message = "resource_aws_memorydb_subnet_group, name and name_prefix cannot both be specified - they are mutually exclusive."
  }
}

variable "description" {
  description = "Description for the subnet group. Defaults to 'Managed by Terraform'."
  type        = string
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}