variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_controltower_landing_zone, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "manifest_json" {
  description = "The manifest JSON file is a text file that describes your AWS resources."
  type        = string

  validation {
    condition     = can(jsondecode(var.manifest_json))
    error_message = "resource_aws_controltower_landing_zone, manifest_json must be valid JSON."
  }

  validation {
    condition     = length(var.manifest_json) > 0
    error_message = "resource_aws_controltower_landing_zone, manifest_json cannot be empty."
  }
}

variable "landing_zone_version" {
  description = "The landing zone version."
  type        = string

  validation {
    condition     = length(var.landing_zone_version) > 0
    error_message = "resource_aws_controltower_landing_zone, landing_zone_version cannot be empty."
  }

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+$", var.landing_zone_version))
    error_message = "resource_aws_controltower_landing_zone, landing_zone_version must be in format X.Y (e.g., 3.2)."
  }
}

variable "tags" {
  description = "Tags to apply to the landing zone."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[\\w\\s+=.:/@-]{1,128}$", k))
    ])
    error_message = "resource_aws_controltower_landing_zone, tags keys must be 1-128 characters and contain only alphanumeric characters, spaces, and the following characters: + - = . _ : / @."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[\\w\\s+=.:/@-]{0,256}$", v))
    ])
    error_message = "resource_aws_controltower_landing_zone, tags values must be 0-256 characters and contain only alphanumeric characters, spaces, and the following characters: + - = . _ : / @."
  }
}

variable "timeout_create" {
  description = "Timeout for creating the Control Tower Landing Zone."
  type        = string
  default     = "120m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_create))
    error_message = "resource_aws_controltower_landing_zone, timeout_create must be a valid duration (e.g., 120m, 2h)."
  }
}

variable "timeout_update" {
  description = "Timeout for updating the Control Tower Landing Zone."
  type        = string
  default     = "120m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_update))
    error_message = "resource_aws_controltower_landing_zone, timeout_update must be a valid duration (e.g., 120m, 2h)."
  }
}

variable "timeout_delete" {
  description = "Timeout for deleting the Control Tower Landing Zone."
  type        = string
  default     = "120m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_delete))
    error_message = "resource_aws_controltower_landing_zone, timeout_delete must be a valid duration (e.g., 120m, 2h)."
  }
}