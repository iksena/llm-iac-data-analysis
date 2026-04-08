variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the source S3 bucket you want Amazon S3 to monitor."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.bucket)) && length(var.bucket) >= 3 && length(var.bucket) <= 63
    error_message = "resource_aws_s3_bucket_replication_configuration, bucket must be a valid S3 bucket name (3-63 characters, lowercase letters, numbers, dots, and hyphens only)."
  }
}

variable "role" {
  description = "ARN of the IAM role for Amazon S3 to assume when replicating the objects."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.role))
    error_message = "resource_aws_s3_bucket_replication_configuration, role must be a valid IAM role ARN."
  }
}

variable "rule" {
  description = "List of configuration blocks describing the rules managing the replication."
  type = list(object({
    delete_marker_replication = optional(object({
      status = string
    }))
    destination = object({
      access_control_translation = optional(object({
        owner = string
      }))
      account = optional(string)
      bucket  = string
      encryption_configuration = optional(object({
        replica_kms_key_id = string
      }))
      metrics = optional(object({
        event_threshold = optional(object({
          minutes = number
        }))
        status = string
      }))
      replication_time = optional(object({
        status = string
        time = object({
          minutes = number
        })
      }))
      storage_class = optional(string)
    })
    existing_object_replication = optional(object({
      status = string
    }))
    filter = optional(object({
      and = optional(object({
        prefix = optional(string)
        tags   = optional(map(string))
      }))
      prefix = optional(string)
      tag = optional(object({
        key   = string
        value = string
      }))
    }))
    id       = optional(string)
    prefix   = optional(string)
    priority = optional(number)
    source_selection_criteria = optional(object({
      replica_modifications = optional(object({
        status = string
      }))
      sse_kms_encrypted_objects = optional(object({
        status = string
      }))
    }))
    status = string
  }))

  validation {
    condition     = length(var.rule) >= 1
    error_message = "resource_aws_s3_bucket_replication_configuration, rule must contain at least one replication rule."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.status == "Enabled" || r.status == "Disabled"
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.id == null || length(r.id) <= 255
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule id must be less than or equal to 255 characters in length."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.prefix == null || length(r.prefix) <= 1024
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule prefix must be less than or equal to 1024 characters in length."
  }

  validation {
    condition = alltrue([
      for r in var.rule : !(r.filter != null && r.prefix != null)
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule filter and prefix cannot both be specified (they are mutually exclusive)."
  }

  validation {
    condition = alltrue([
      for r in var.rule : can(regex("^arn:aws:s3:::", r.destination.bucket))
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule destination bucket must be a valid S3 bucket ARN."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.destination.account == null || can(regex("^[0-9]{12}$", r.destination.account))
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule destination account must be a 12-digit AWS account ID."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.destination.access_control_translation == null || r.destination.access_control_translation.owner == "Destination"
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule destination access_control_translation owner must be 'Destination'."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.destination.encryption_configuration == null || can(regex("^arn:aws:kms:", r.destination.encryption_configuration.replica_kms_key_id))
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule destination encryption_configuration replica_kms_key_id must be a valid KMS key ARN."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.destination.metrics == null || (r.destination.metrics.status == "Enabled" || r.destination.metrics.status == "Disabled")
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule destination metrics status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.destination.metrics == null || r.destination.metrics.event_threshold == null || r.destination.metrics.event_threshold.minutes == 15
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule destination metrics event_threshold minutes must be 15."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.destination.replication_time == null || (r.destination.replication_time.status == "Enabled" || r.destination.replication_time.status == "Disabled")
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule destination replication_time status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.destination.replication_time == null || r.destination.replication_time.time.minutes == 15
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule destination replication_time time minutes must be 15."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.destination.storage_class == null || contains([
        "STANDARD", "REDUCED_REDUNDANCY", "STANDARD_IA", "ONEZONE_IA",
        "INTELLIGENT_TIERING", "GLACIER", "DEEP_ARCHIVE", "GLACIER_IR"
      ], r.destination.storage_class)
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule destination storage_class must be a valid S3 storage class."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.delete_marker_replication == null || (r.delete_marker_replication.status == "Enabled" || r.delete_marker_replication.status == "Disabled")
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule delete_marker_replication status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.existing_object_replication == null || (r.existing_object_replication.status == "Enabled" || r.existing_object_replication.status == "Disabled")
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule existing_object_replication status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.filter == null || r.filter.prefix == null || length(r.filter.prefix) <= 1024
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule filter prefix must be less than or equal to 1024 characters in length."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.filter == null || r.filter.and == null || r.filter.and.prefix == null || length(r.filter.and.prefix) <= 1024
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule filter and prefix must be less than or equal to 1024 characters in length."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.source_selection_criteria == null || r.source_selection_criteria.replica_modifications == null || (r.source_selection_criteria.replica_modifications.status == "Enabled" || r.source_selection_criteria.replica_modifications.status == "Disabled")
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule source_selection_criteria replica_modifications status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.source_selection_criteria == null || r.source_selection_criteria.sse_kms_encrypted_objects == null || (r.source_selection_criteria.sse_kms_encrypted_objects.status == "Enabled" || r.source_selection_criteria.sse_kms_encrypted_objects.status == "Disabled")
    ])
    error_message = "resource_aws_s3_bucket_replication_configuration, rule source_selection_criteria sse_kms_encrypted_objects status must be either 'Enabled' or 'Disabled'."
  }
}

variable "token" {
  description = "Token to allow replication to be enabled on an Object Lock-enabled bucket. You must contact AWS support for the bucket's 'Object Lock token'."
  type        = string
  default     = null
  sensitive   = true
}