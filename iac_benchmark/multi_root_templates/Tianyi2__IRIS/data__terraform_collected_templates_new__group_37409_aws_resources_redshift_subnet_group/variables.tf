variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the Redshift Subnet group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.name))
    error_message = "resource_aws_redshift_subnet_group, name must start with a letter and contain only alphanumeric characters and hyphens."
  }
}

variable "description" {
  description = "The description of the Redshift Subnet group. Defaults to 'Managed by Terraform'."
  type        = string
  default     = "Managed by Terraform"
}

variable "subnet_ids" {
  description = "An array of VPC subnet IDs."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_redshift_subnet_group, subnet_ids must contain at least one subnet ID."
  }

  validation {
    condition     = alltrue([for subnet_id in var.subnet_ids : can(regex("^subnet-[a-f0-9]{8,17}$", subnet_id))])
    error_message = "resource_aws_redshift_subnet_group, subnet_ids must contain valid subnet IDs (format: subnet-xxxxxxxxx)."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}