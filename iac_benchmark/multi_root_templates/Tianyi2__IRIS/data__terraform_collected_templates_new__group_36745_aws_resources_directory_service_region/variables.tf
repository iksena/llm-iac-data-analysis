variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "desired_number_of_domain_controllers" {
  description = "The number of domain controllers desired in the replicated directory. Minimum value of 2."
  type        = number
  default     = null

  validation {
    condition     = var.desired_number_of_domain_controllers == null || var.desired_number_of_domain_controllers >= 2
    error_message = "resource_aws_directory_service_region, desired_number_of_domain_controllers must be at least 2."
  }
}

variable "directory_id" {
  description = "The identifier of the directory to which you want to add Region replication."
  type        = string

  validation {
    condition     = can(regex("^d-[0-9a-f]{10}$", var.directory_id))
    error_message = "resource_aws_directory_service_region, directory_id must be a valid directory ID format (d-xxxxxxxxxx)."
  }
}

variable "region_name" {
  description = "The name of the Region where you want to add domain controllers for replication."
  type        = string

  validation {
    condition     = length(var.region_name) > 0
    error_message = "resource_aws_directory_service_region, region_name cannot be empty."
  }
}

variable "tags" {
  description = "Map of tags to assign to this resource."
  type        = map(string)
  default     = {}
}

variable "vpc_settings" {
  description = "VPC information in the replicated Region."
  type = object({
    subnet_ids = list(string)
    vpc_id     = optional(string)
  })

  validation {
    condition     = length(var.vpc_settings.subnet_ids) > 0
    error_message = "resource_aws_directory_service_region, vpc_settings.subnet_ids must contain at least one subnet ID."
  }

  validation {
    condition = alltrue([
      for subnet_id in var.vpc_settings.subnet_ids : can(regex("^subnet-[0-9a-f]{8,17}$", subnet_id))
    ])
    error_message = "resource_aws_directory_service_region, vpc_settings.subnet_ids must contain valid subnet ID formats."
  }

  validation {
    condition     = var.vpc_settings.vpc_id == null || can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_settings.vpc_id))
    error_message = "resource_aws_directory_service_region, vpc_settings.vpc_id must be a valid VPC ID format when specified."
  }
}

variable "timeouts" {
  description = "Timeout configuration for the resource operations."
  type = object({
    create = optional(string, "180m")
    update = optional(string, "90m")
    delete = optional(string, "90m")
  })
  default = {}
}