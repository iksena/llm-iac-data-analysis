variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Availability zone where the EBS volume will exist."
  type        = string

  validation {
    condition     = var.availability_zone != null && var.availability_zone != ""
    error_message = "resource_aws_ebs_volume, availability_zone is required and cannot be empty."
  }
}

variable "encrypted" {
  description = "If true, the disk will be encrypted."
  type        = bool
  default     = null
}

variable "final_snapshot" {
  description = "If true, snapshot will be created before volume deletion. Any tags on the volume will be migrated to the snapshot. By default set to false"
  type        = bool
  default     = false
}

variable "iops" {
  description = "Amount of IOPS to provision for the disk. Only valid for type of io1, io2 or gp3."
  type        = number
  default     = null

  validation {
    condition = var.iops == null || (
      var.iops >= 100 && var.iops <= 64000
    )
    error_message = "resource_aws_ebs_volume, iops must be between 100 and 64000 when specified."
  }
}

variable "kms_key_id" {
  description = "ARN for the KMS encryption key. When specifying kms_key_id, encrypted needs to be set to true."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_id == null || can(regex("^arn:aws:kms:", var.kms_key_id))
    error_message = "resource_aws_ebs_volume, kms_key_id must be a valid KMS key ARN when specified."
  }
}

variable "multi_attach_enabled" {
  description = "Specifies whether to enable Amazon EBS Multi-Attach. Multi-Attach is supported on io1 and io2 volumes."
  type        = bool
  default     = null
}

variable "outpost_arn" {
  description = "Amazon Resource Name (ARN) of the Outpost."
  type        = string
  default     = null

  validation {
    condition     = var.outpost_arn == null || can(regex("^arn:aws:outposts:", var.outpost_arn))
    error_message = "resource_aws_ebs_volume, outpost_arn must be a valid Outpost ARN when specified."
  }
}

variable "size" {
  description = "Size of the drive in GiBs."
  type        = number
  default     = null

  validation {
    condition     = var.size == null || var.size > 0
    error_message = "resource_aws_ebs_volume, size must be greater than 0 when specified."
  }
}

variable "snapshot_id" {
  description = "A snapshot to base the EBS volume off of."
  type        = string
  default     = null

  validation {
    condition     = var.snapshot_id == null || can(regex("^snap-[a-f0-9]+$", var.snapshot_id))
    error_message = "resource_aws_ebs_volume, snapshot_id must be a valid snapshot ID format (snap-xxxxxxxx) when specified."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "throughput" {
  description = "Throughput that the volume supports, in MiB/s. Only valid for type of gp3."
  type        = number
  default     = null

  validation {
    condition     = var.throughput == null || (var.throughput >= 125 && var.throughput <= 1000)
    error_message = "resource_aws_ebs_volume, throughput must be between 125 and 1000 MiB/s when specified."
  }
}

variable "type" {
  description = "Type of EBS volume. Can be standard, gp2, gp3, io1, io2, sc1 or st1."
  type        = string
  default     = "gp2"

  validation {
    condition     = contains(["standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"], var.type)
    error_message = "resource_aws_ebs_volume, type must be one of: standard, gp2, gp3, io1, io2, sc1, st1."
  }
}

variable "volume_initialization_rate" {
  description = "EBS provisioned rate for volume initialization, in MiB/s, at which to download the snapshot blocks from Amazon S3 to the volume. This argument can only be set if snapshot_id is specified."
  type        = number
  default     = null

  validation {
    condition     = var.volume_initialization_rate == null || (var.volume_initialization_rate > 0 && var.volume_initialization_rate <= 1000)
    error_message = "resource_aws_ebs_volume, volume_initialization_rate must be between 1 and 1000 MiB/s when specified."
  }
}

variable "timeouts" {
  description = "Configuration block for timeout values."
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "10m")
  })
  default = null
}

# Validation to ensure at least one of size or snapshot_id is provided
locals {
  size_or_snapshot_provided = var.size != null || var.snapshot_id != null
}

variable "validate_size_or_snapshot" {
  description = "Internal validation variable - do not set manually"
  type        = bool
  default     = true

  validation {
    condition     = var.validate_size_or_snapshot
    error_message = "resource_aws_ebs_volume, at least one of size or snapshot_id must be specified."
  }
}