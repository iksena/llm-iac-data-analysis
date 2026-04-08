variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_internet_gateway, region must be a valid AWS region format (e.g., us-west-2)"
  }
}

variable "vpc_id" {
  description = "The VPC ID to create in"
  type        = string
  default     = null
  validation {
    condition     = var.vpc_id == null || can(regex("^vpc-[a-z0-9]{8,17}$", var.vpc_id))
    error_message = "resource_aws_internet_gateway, vpc_id must be a valid VPC ID format (vpc-xxxxxxxxx)"
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
  validation {
    condition     = alltrue([for k, v in var.tags : can(tostring(k)) && can(tostring(v))])
    error_message = "resource_aws_internet_gateway, tags must be a map of strings"
  }
}

variable "timeout_create" {
  description = "Timeout for create operation"
  type        = string
  default     = "20m"
  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeout_create))
    error_message = "resource_aws_internet_gateway, timeout_create must be a valid duration format (e.g., 20m, 1h, 30s)"
  }
}

variable "timeout_update" {
  description = "Timeout for update operation"
  type        = string
  default     = "20m"
  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeout_update))
    error_message = "resource_aws_internet_gateway, timeout_update must be a valid duration format (e.g., 20m, 1h, 30s)"
  }
}

variable "timeout_delete" {
  description = "Timeout for delete operation"
  type        = string
  default     = "20m"
  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeout_delete))
    error_message = "resource_aws_internet_gateway, timeout_delete must be a valid duration format (e.g., 20m, 1h, 30s)"
  }
}