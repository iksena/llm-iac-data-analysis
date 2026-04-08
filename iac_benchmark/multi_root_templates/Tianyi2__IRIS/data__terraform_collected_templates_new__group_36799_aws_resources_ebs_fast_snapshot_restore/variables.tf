variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Availability zone in which to enable fast snapshot restores."
  type        = string

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+-[0-9]+[a-z]$", var.availability_zone))
    error_message = "resource_aws_ebs_fast_snapshot_restore, availability_zone must be a valid AWS availability zone format (e.g., us-west-2a)."
  }
}

variable "snapshot_id" {
  description = "ID of the snapshot."
  type        = string

  validation {
    condition     = can(regex("^snap-[0-9a-f]{8,17}$", var.snapshot_id))
    error_message = "resource_aws_ebs_fast_snapshot_restore, snapshot_id must be a valid AWS snapshot ID format (e.g., snap-abcdef123456)."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    delete = "10m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_ebs_fast_snapshot_restore, timeouts must be valid duration strings (e.g., 10m, 1h, 30s)."
  }
}