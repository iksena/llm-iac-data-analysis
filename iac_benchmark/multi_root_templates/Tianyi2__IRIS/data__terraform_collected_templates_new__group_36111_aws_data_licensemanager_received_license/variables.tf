variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_licensemanager_received_licenses, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "filter" {
  description = "Custom filter block to filter the received licenses."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_licensemanager_received_licenses, filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_licensemanager_received_licenses, filter values must contain at least one value."
  }

  validation {
    condition = alltrue([
      for f in var.filter : alltrue([
        for v in f.values : v != null && v != ""
      ])
    ])
    error_message = "data_aws_licensemanager_received_licenses, filter values cannot contain null or empty strings."
  }
}