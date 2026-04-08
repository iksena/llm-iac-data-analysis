variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the license configuration."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_licensemanager_license_configuration, name must not be empty."
  }
}

variable "description" {
  description = "Description of the license configuration."
  type        = string
  default     = null
}

variable "license_count" {
  description = "Number of licenses managed by the license configuration."
  type        = number
  default     = null

  validation {
    condition     = var.license_count == null || var.license_count >= 0
    error_message = "resource_aws_licensemanager_license_configuration, license_count must be a non-negative number."
  }
}

variable "license_count_hard_limit" {
  description = "Sets the number of available licenses as a hard limit."
  type        = bool
  default     = null
}

variable "license_counting_type" {
  description = "Dimension to use to track license inventory. Specify either vCPU, Instance, Core or Socket."
  type        = string

  validation {
    condition     = contains(["vCPU", "Instance", "Core", "Socket"], var.license_counting_type)
    error_message = "resource_aws_licensemanager_license_configuration, license_counting_type must be one of: vCPU, Instance, Core, Socket."
  }
}

variable "license_rules" {
  description = "Array of configured License Manager rules."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}