variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "Name of the MemoryDB cluster to take a snapshot of."
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "resource_aws_memorydb_snapshot, cluster_name must not be empty."
  }
}

variable "name" {
  description = "Name of the snapshot. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || (can(regex("^[a-z][a-z0-9-]{0,39}$", var.name)) && !can(regex("--", var.name)) && !can(regex("-$", var.name)))
    error_message = "resource_aws_memorydb_snapshot, name must be 1-40 characters long, start with a letter, contain only lowercase letters, numbers, and hyphens, not contain consecutive hyphens, and not end with a hyphen."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || (can(regex("^[a-z][a-z0-9-]{0,35}$", var.name_prefix)) && !can(regex("--", var.name_prefix)) && !can(regex("-$", var.name_prefix)))
    error_message = "resource_aws_memorydb_snapshot, name_prefix must be 1-36 characters long, start with a letter, contain only lowercase letters, numbers, and hyphens, not contain consecutive hyphens, and not end with a hyphen."
  }

  validation {
    condition     = !(var.name != null && var.name_prefix != null)
    error_message = "resource_aws_memorydb_snapshot, name_prefix conflicts with name. Only one can be specified."
  }
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the snapshot at rest."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.kms_key_arn))
    error_message = "resource_aws_memorydb_snapshot, kms_key_arn must be a valid KMS key ARN."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for creating the snapshot."
  type        = string
  default     = "120m"
}

variable "delete_timeout" {
  description = "Timeout for deleting the snapshot."
  type        = string
  default     = "120m"
}