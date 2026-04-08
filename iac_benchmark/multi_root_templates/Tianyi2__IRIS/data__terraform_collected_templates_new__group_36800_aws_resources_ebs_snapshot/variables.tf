variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "volume_id" {
  description = "The Volume ID of which to make a snapshot."
  type        = string

  validation {
    condition     = can(regex("^vol-[0-9a-f]{8}([0-9a-f]{9})?$", var.volume_id))
    error_message = "resource_aws_ebs_snapshot, volume_id must be a valid EBS volume ID (vol-xxxxxxxx or vol-xxxxxxxxxxxxxxxxx)."
  }
}

variable "description" {
  description = "A description of what the snapshot is."
  type        = string
  default     = null
}

variable "outpost_arn" {
  description = "The Amazon Resource Name (ARN) of the Outpost on which to create a local snapshot."
  type        = string
  default     = null

  validation {
    condition     = var.outpost_arn == null || can(regex("^arn:aws:outposts:[a-z0-9-]+:[0-9]{12}:outpost/op-[0-9a-f]+$", var.outpost_arn))
    error_message = "resource_aws_ebs_snapshot, outpost_arn must be a valid Outpost ARN or null."
  }
}

variable "storage_tier" {
  description = "The name of the storage tier. Valid values are archive and standard. Default value is standard."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["archive", "standard"], var.storage_tier)
    error_message = "resource_aws_ebs_snapshot, storage_tier must be either 'archive' or 'standard'."
  }
}

variable "permanent_restore" {
  description = "Indicates whether to permanently restore an archived snapshot."
  type        = bool
  default     = null
}

variable "temporary_restore_days" {
  description = "Specifies the number of days for which to temporarily restore an archived snapshot. Required for temporary restores only. The snapshot will be automatically re-archived after this period."
  type        = number
  default     = null

  validation {
    condition     = var.temporary_restore_days == null || (var.temporary_restore_days >= 1 && var.temporary_restore_days <= 180)
    error_message = "resource_aws_ebs_snapshot, temporary_restore_days must be between 1 and 180 days or null."
  }
}

variable "tags" {
  description = "A map of tags to assign to the snapshot. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    delete = "10m"
  }

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts.create)) && can(regex("^[0-9]+(s|m|h)$", var.timeouts.delete))
    error_message = "resource_aws_ebs_snapshot, timeouts must be valid duration strings (e.g., '10m', '1h', '30s')."
  }
}