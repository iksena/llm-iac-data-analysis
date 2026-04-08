variable "capacity_block_offering_id" {
  description = "The Capacity Block Reservation ID"
  type        = string

  validation {
    condition     = length(var.capacity_block_offering_id) > 0
    error_message = "resource_aws_ec2_capacity_block_reservation, capacity_block_offering_id must not be empty."
  }
}

variable "instance_platform" {
  description = "The type of operating system for which to reserve capacity"
  type        = string

  validation {
    condition = contains([
      "Linux/UNIX",
      "Red Hat Enterprise Linux",
      "SUSE Linux",
      "Windows",
      "Windows with SQL Server",
      "Windows with SQL Server Enterprise",
      "Windows with SQL Server Standard",
      "Windows with SQL Server Web"
    ], var.instance_platform)
    error_message = "resource_aws_ec2_capacity_block_reservation, instance_platform must be one of: Linux/UNIX, Red Hat Enterprise Linux, SUSE Linux, Windows, Windows with SQL Server, Windows with SQL Server Enterprise, Windows with SQL Server Standard, Windows with SQL Server Web."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}