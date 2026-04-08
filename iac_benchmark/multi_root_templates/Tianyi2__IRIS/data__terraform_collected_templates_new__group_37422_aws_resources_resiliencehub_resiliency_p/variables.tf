variable "name" {
  description = "Name of Resiliency Policy. Must be between 2 and 60 characters long. Must start with an alphanumeric character and contain alphanumeric characters, underscores, or hyphens."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.name)) && length(var.name) >= 2 && length(var.name) <= 60
    error_message = "resource_aws_resiliencehub_resiliency_policy, name must be between 2 and 60 characters long, start with an alphanumeric character and contain only alphanumeric characters, underscores, or hyphens."
  }
}

variable "tier" {
  description = "Resiliency Policy Tier. Valid values are MissionCritical, Critical, Important, CoreServices, NonCritical, and NotApplicable."
  type        = string

  validation {
    condition     = contains(["MissionCritical", "Critical", "Important", "CoreServices", "NonCritical", "NotApplicable"], var.tier)
    error_message = "resource_aws_resiliencehub_resiliency_policy, tier must be one of: MissionCritical, Critical, Important, CoreServices, NonCritical, NotApplicable."
  }
}

variable "description" {
  description = "Description of Resiliency Policy."
  type        = string
  default     = null
}

variable "data_location_constraint" {
  description = "Data Location Constraint of the Policy. Valid values are AnyLocation, SameContinent, and SameCountry."
  type        = string
  default     = null

  validation {
    condition     = var.data_location_constraint == null || contains(["AnyLocation", "SameContinent", "SameCountry"], var.data_location_constraint)
    error_message = "resource_aws_resiliencehub_resiliency_policy, data_location_constraint must be one of: AnyLocation, SameContinent, SameCountry."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "policy" {
  description = "The type of resiliency policy to be created, including the recovery time objective (RTO) and recovery point objective (RPO)."
  type = object({
    region = optional(object({
      rpo = string
      rto = string
    }))
    az = object({
      rpo = string
      rto = string
    })
    hardware = object({
      rpo = string
      rto = string
    })
    software = object({
      rpo = string
      rto = string
    })
  })

  validation {
    condition     = can(regex("^[0-9]+(ns|us|ms|s|m|h)$", var.policy.az.rpo))
    error_message = "resource_aws_resiliencehub_resiliency_policy, policy.az.rpo must be a valid Go duration (e.g., 1h, 2h45m, 30m15s)."
  }

  validation {
    condition     = can(regex("^[0-9]+(ns|us|ms|s|m|h)$", var.policy.az.rto))
    error_message = "resource_aws_resiliencehub_resiliency_policy, policy.az.rto must be a valid Go duration (e.g., 1h, 2h45m, 30m15s)."
  }

  validation {
    condition     = can(regex("^[0-9]+(ns|us|ms|s|m|h)$", var.policy.hardware.rpo))
    error_message = "resource_aws_resiliencehub_resiliency_policy, policy.hardware.rpo must be a valid Go duration (e.g., 1h, 2h45m, 30m15s)."
  }

  validation {
    condition     = can(regex("^[0-9]+(ns|us|ms|s|m|h)$", var.policy.hardware.rto))
    error_message = "resource_aws_resiliencehub_resiliency_policy, policy.hardware.rto must be a valid Go duration (e.g., 1h, 2h45m, 30m15s)."
  }

  validation {
    condition     = can(regex("^[0-9]+(ns|us|ms|s|m|h)$", var.policy.software.rpo))
    error_message = "resource_aws_resiliencehub_resiliency_policy, policy.software.rpo must be a valid Go duration (e.g., 1h, 2h45m, 30m15s)."
  }

  validation {
    condition     = can(regex("^[0-9]+(ns|us|ms|s|m|h)$", var.policy.software.rto))
    error_message = "resource_aws_resiliencehub_resiliency_policy, policy.software.rto must be a valid Go duration (e.g., 1h, 2h45m, 30m15s)."
  }

  validation {
    condition     = var.policy.region == null || can(regex("^[0-9]+(ns|us|ms|s|m|h)$", var.policy.region.rpo))
    error_message = "resource_aws_resiliencehub_resiliency_policy, policy.region.rpo must be a valid Go duration (e.g., 1h, 2h45m, 30m15s)."
  }

  validation {
    condition     = var.policy.region == null || can(regex("^[0-9]+(ns|us|ms|s|m|h)$", var.policy.region.rto))
    error_message = "resource_aws_resiliencehub_resiliency_policy, policy.region.rto must be a valid Go duration (e.g., 1h, 2h45m, 30m15s)."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}