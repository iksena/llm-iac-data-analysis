variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the neptune subnet group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the neptune subnet group. Defaults to 'Managed by Terraform'."
  type        = string
  default     = "Managed by Terraform"
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_neptune_subnet_group, subnet_ids must contain at least one subnet ID."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}