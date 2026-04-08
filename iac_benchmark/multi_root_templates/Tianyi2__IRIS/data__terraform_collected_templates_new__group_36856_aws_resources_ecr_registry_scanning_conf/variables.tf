variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "scan_type" {
  description = "The scanning type to set for the registry. Can be either ENHANCED or BASIC."
  type        = string

  validation {
    condition     = contains(["ENHANCED", "BASIC"], var.scan_type)
    error_message = "resource_aws_ecr_registry_scanning_configuration, scan_type must be either 'ENHANCED' or 'BASIC'."
  }
}

variable "rule" {
  description = "One or multiple blocks specifying scanning rules to determine which repository filters are used and at what frequency scanning will occur."
  type = list(object({
    repository_filter = list(object({
      filter      = string
      filter_type = string
    }))
    scan_frequency = string
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.rule : contains(["SCAN_ON_PUSH", "CONTINUOUS_SCAN", "MANUAL"], r.scan_frequency)
    ])
    error_message = "resource_aws_ecr_registry_scanning_configuration, scan_frequency must be 'SCAN_ON_PUSH', 'CONTINUOUS_SCAN', or 'MANUAL'."
  }

  validation {
    condition = alltrue([
      for r in var.rule : alltrue([
        for rf in r.repository_filter : contains(["WILDCARD"], rf.filter_type)
      ])
    ])
    error_message = "resource_aws_ecr_registry_scanning_configuration, filter_type must be 'WILDCARD'."
  }
}