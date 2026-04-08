variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "capacity_duration_hours" {
  type        = number
  description = "The amount of time of the Capacity Block reservation in hours."

  validation {
    condition     = var.capacity_duration_hours > 0
    error_message = "data_aws_ec2_capacity_block_offering, capacity_duration_hours must be greater than 0."
  }
}

variable "end_date_range" {
  type        = string
  description = "The date and time at which the Capacity Block Reservation expires. Valid values: RFC3339 time string (YYYY-MM-DDTHH:MM:SSZ)"
  default     = null

  validation {
    condition     = var.end_date_range == null || can(formatdate("RFC3339", var.end_date_range))
    error_message = "data_aws_ec2_capacity_block_offering, end_date_range must be a valid RFC3339 time string (YYYY-MM-DDTHH:MM:SSZ)."
  }
}

variable "instance_count" {
  type        = number
  description = "The number of instances for which to reserve capacity."

  validation {
    condition     = var.instance_count > 0
    error_message = "data_aws_ec2_capacity_block_offering, instance_count must be greater than 0."
  }
}

variable "instance_type" {
  type        = string
  description = "The instance type for which to reserve capacity."

  validation {
    condition     = length(var.instance_type) > 0
    error_message = "data_aws_ec2_capacity_block_offering, instance_type cannot be empty."
  }
}

variable "start_date_range" {
  type        = string
  description = "The date and time at which the Capacity Block Reservation starts. Valid values: RFC3339 time string (YYYY-MM-DDTHH:MM:SSZ)"
  default     = null

  validation {
    condition     = var.start_date_range == null || can(formatdate("RFC3339", var.start_date_range))
    error_message = "data_aws_ec2_capacity_block_offering, start_date_range must be a valid RFC3339 time string (YYYY-MM-DDTHH:MM:SSZ)."
  }
}