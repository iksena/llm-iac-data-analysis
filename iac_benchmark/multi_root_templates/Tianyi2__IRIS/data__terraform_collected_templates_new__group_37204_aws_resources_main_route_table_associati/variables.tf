variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The ID of the VPC whose main route table should be set"
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "resource_aws_main_route_table_association, vpc_id must be a valid VPC ID (format: vpc-xxxxxxxx or vpc-xxxxxxxxxxxxxxxxx)."
  }
}

variable "route_table_id" {
  description = "The ID of the Route Table to set as the new main route table for the target VPC"
  type        = string

  validation {
    condition     = can(regex("^rtb-[0-9a-f]{8,17}$", var.route_table_id))
    error_message = "resource_aws_main_route_table_association, route_table_id must be a valid Route Table ID (format: rtb-xxxxxxxx or rtb-xxxxxxxxxxxxxxxxx)."
  }
}

variable "timeout_create" {
  description = "Timeout for creating the main route table association"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_create))
    error_message = "resource_aws_main_route_table_association, timeout_create must be a valid duration (e.g., 5m, 30s, 1h)."
  }
}

variable "timeout_update" {
  description = "Timeout for updating the main route table association"
  type        = string
  default     = "2m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_update))
    error_message = "resource_aws_main_route_table_association, timeout_update must be a valid duration (e.g., 5m, 30s, 1h)."
  }
}

variable "timeout_delete" {
  description = "Timeout for deleting the main route table association"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_delete))
    error_message = "resource_aws_main_route_table_association, timeout_delete must be a valid duration (e.g., 5m, 30s, 1h)."
  }
}