variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the DB subnet group"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the DB subnet group"
  type        = string
  default     = "Managed by Terraform"
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_db_subnet_group, subnet_ids must contain at least one subnet ID."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}