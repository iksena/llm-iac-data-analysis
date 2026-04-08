variable "availability_zone" {
  description = "The Availability Zone in which to create the Capacity Reservation"
  type        = string

  validation {
    condition     = length(var.availability_zone) > 0
    error_message = "resource_aws_ec2_capacity_reservation, availability_zone must be a non-empty string."
  }
}

variable "instance_count" {
  description = "The number of instances for which to reserve capacity"
  type        = number

  validation {
    condition     = var.instance_count > 0
    error_message = "resource_aws_ec2_capacity_reservation, instance_count must be greater than 0."
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
    error_message = "resource_aws_ec2_capacity_reservation, instance_platform must be one of: Linux/UNIX, Red Hat Enterprise Linux, SUSE Linux, Windows, Windows with SQL Server, Windows with SQL Server Enterprise, Windows with SQL Server Standard, Windows with SQL Server Web."
  }
}

variable "instance_type" {
  description = "The instance type for which to reserve capacity"
  type        = string

  validation {
    condition     = length(var.instance_type) > 0
    error_message = "resource_aws_ec2_capacity_reservation, instance_type must be a non-empty string."
  }
}

variable "ebs_optimized" {
  description = "Indicates whether the Capacity Reservation supports EBS-optimized instances"
  type        = bool
  default     = null
}

variable "end_date" {
  description = "The date and time at which the Capacity Reservation expires. Valid values: RFC3339 time string (YYYY-MM-DDTHH:MM:SSZ)"
  type        = string
  default     = null

  validation {
    condition     = var.end_date == null || can(formatdate("RFC3339", var.end_date))
    error_message = "resource_aws_ec2_capacity_reservation, end_date must be a valid RFC3339 time string (YYYY-MM-DDTHH:MM:SSZ)."
  }
}

variable "end_date_type" {
  description = "Indicates the way in which the Capacity Reservation ends. Specify either unlimited or limited"
  type        = string
  default     = null

  validation {
    condition     = var.end_date_type == null || contains(["unlimited", "limited"], var.end_date_type)
    error_message = "resource_aws_ec2_capacity_reservation, end_date_type must be either 'unlimited' or 'limited'."
  }
}

variable "ephemeral_storage" {
  description = "Indicates whether the Capacity Reservation supports instances with temporary, block-level storage"
  type        = bool
  default     = null
}

variable "instance_match_criteria" {
  description = "Indicates the type of instance launches that the Capacity Reservation accepts. Specify either open or targeted"
  type        = string
  default     = null

  validation {
    condition     = var.instance_match_criteria == null || contains(["open", "targeted"], var.instance_match_criteria)
    error_message = "resource_aws_ec2_capacity_reservation, instance_match_criteria must be either 'open' or 'targeted'."
  }
}

variable "outpost_arn" {
  description = "The Amazon Resource Name (ARN) of the Outpost on which to create the Capacity Reservation"
  type        = string
  default     = null

  validation {
    condition     = var.outpost_arn == null || can(regex("^arn:aws[a-zA-Z-]*:outposts:", var.outpost_arn))
    error_message = "resource_aws_ec2_capacity_reservation, outpost_arn must be a valid ARN starting with 'arn:aws'."
  }
}

variable "placement_group_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster placement group in which to create the Capacity Reservation"
  type        = string
  default     = null

  validation {
    condition     = var.placement_group_arn == null || can(regex("^arn:aws[a-zA-Z-]*:ec2:", var.placement_group_arn))
    error_message = "resource_aws_ec2_capacity_reservation, placement_group_arn must be a valid ARN starting with 'arn:aws'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "tenancy" {
  description = "Indicates the tenancy of the Capacity Reservation. Specify either default or dedicated"
  type        = string
  default     = null

  validation {
    condition     = var.tenancy == null || contains(["default", "dedicated"], var.tenancy)
    error_message = "resource_aws_ec2_capacity_reservation, tenancy must be either 'default' or 'dedicated'."
  }
}

variable "timeouts" {
  description = "Timeouts for create, update and delete operations"
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}