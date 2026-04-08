variable "name" {
  description = "The name for the instance profile"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_devicefarm_instance_profile, name must be a non-empty string."
  }
}

variable "description" {
  description = "The description of the instance profile"
  type        = string
  default     = null
}

variable "exclude_app_packages_from_cleanup" {
  description = "An array of strings that specifies the list of app packages that should not be cleaned up from the device after a test run"
  type        = list(string)
  default     = null

  validation {
    condition = var.exclude_app_packages_from_cleanup == null || (
      length(var.exclude_app_packages_from_cleanup) >= 0 &&
      alltrue([for pkg in var.exclude_app_packages_from_cleanup : length(pkg) > 0])
    )
    error_message = "resource_aws_devicefarm_instance_profile, exclude_app_packages_from_cleanup must be a list of non-empty strings or null."
  }
}

variable "package_cleanup" {
  description = "When set to true, Device Farm removes app packages after a test run. The default value is false for private devices"
  type        = bool
  default     = null
}

variable "reboot_after_use" {
  description = "When set to true, Device Farm reboots the instance after a test run. The default value is true"
  type        = bool
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.tags : length(key) > 0 && length(value) >= 0
    ])
    error_message = "resource_aws_devicefarm_instance_profile, tags must have non-empty keys and non-null values."
  }
}