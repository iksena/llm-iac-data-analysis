variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length."
  type        = string
  default     = null

  validation {
    condition = var.bucket == null || (
      can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket)) &&
      length(var.bucket) <= 63 &&
      length(var.bucket) >= 3 &&
      !can(regex("--", var.bucket)) &&
      !can(regex("^[0-9.]+$", var.bucket)) &&
      !can(regex("^[.-]", var.bucket)) &&
      !can(regex("[.-]$", var.bucket)) &&
      !can(regex(".*--.*--x-s3$", var.bucket))
    )
    error_message = "resource_aws_s3_bucket, bucket must be lowercase, between 3-63 characters, start and end with alphanumeric, no consecutive dots/hyphens, not IP address format, and not in format [bucket_name]--[azid]--x-s3."
  }
}

variable "bucket_prefix" {
  description = "Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket. Must be lowercase and less than or equal to 37 characters in length."
  type        = string
  default     = null

  validation {
    condition = var.bucket_prefix == null || (
      can(regex("^[a-z0-9][a-z0-9.-]*$", var.bucket_prefix)) &&
      length(var.bucket_prefix) <= 37 &&
      length(var.bucket_prefix) >= 1
    )
    error_message = "resource_aws_s3_bucket, bucket_prefix must be lowercase, between 1-37 characters, and follow bucket naming rules."
  }
}

variable "force_destroy" {
  description = "Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error."
  type        = bool
  default     = false
}

variable "object_lock_enabled" {
  description = "Indicates whether this bucket has an Object Lock configuration enabled. Valid values are true or false."
  type        = bool
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

# Deprecated variables
variable "acceleration_status" {
  description = "(Deprecated) Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended."
  type        = string
  default     = null

  validation {
    condition     = var.acceleration_status == null || contains(["Enabled", "Suspended"], var.acceleration_status)
    error_message = "resource_aws_s3_bucket, acceleration_status must be either 'Enabled' or 'Suspended'."
  }
}

variable "acl" {
  description = "(Deprecated) The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write."
  type        = string
  default     = null

  validation {
    condition = var.acl == null || contains([
      "private", "public-read", "public-read-write",
      "aws-exec-read", "authenticated-read", "log-delivery-write"
    ], var.acl)
    error_message = "resource_aws_s3_bucket, acl must be one of: private, public-read, public-read-write, aws-exec-read, authenticated-read, log-delivery-write."
  }
}

variable "grant" {
  description = "(Deprecated) An ACL policy grant configuration."
  type = list(object({
    id          = optional(string)
    type        = string
    permissions = list(string)
    uri         = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for grant in var.grant : contains(["CanonicalUser", "Group"], grant.type)
    ])
    error_message = "resource_aws_s3_bucket, grant type must be either 'CanonicalUser' or 'Group'."
  }

  validation {
    condition = alltrue([
      for grant in var.grant : alltrue([
        for permission in grant.permissions : contains(["READ", "WRITE", "READ_ACP", "WRITE_ACP", "FULL_CONTROL"], permission)
      ])
    ])
    error_message = "resource_aws_s3_bucket, grant permissions must be one of: READ, WRITE, READ_ACP, WRITE_ACP, FULL_CONTROL."
  }
}

variable "cors_rule" {
  description = "(Deprecated) Rule of Cross-Origin Resource Sharing."
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.cors_rule : alltrue([
        for method in rule.allowed_methods : contains(["GET", "PUT", "POST", "DELETE", "HEAD"], method)
      ])
    ])
    error_message = "resource_aws_s3_bucket, cors_rule allowed_methods must be one of: GET, PUT, POST, DELETE, HEAD."
  }
}

variable "lifecycle_rule" {
  description = "(Deprecated) Configuration of object lifecycle management."
  type = list(object({
    id                                     = optional(string)
    prefix                                 = optional(string)
    tags                                   = optional(map(string))
    enabled                                = bool
    abort_incomplete_multipart_upload_days = optional(number)
    expiration = optional(object({
      date                         = optional(string)
      days                         = optional(number)
      expired_object_delete_marker = optional(bool)
    }))
    transition = optional(list(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = string
    })), [])
    noncurrent_version_expiration = optional(object({
      days = number
    }))
    noncurrent_version_transition = optional(list(object({
      days          = number
      storage_class = string
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.lifecycle_rule : rule.id == null || length(rule.id) <= 255
    ])
    error_message = "resource_aws_s3_bucket, lifecycle_rule id must be less than or equal to 255 characters in length."
  }
}

variable "logging" {
  description = "(Deprecated) Configuration of S3 bucket logging parameters."
  type = object({
    target_bucket = string
    target_prefix = optional(string)
  })
  default = null
}

variable "object_lock_configuration" {
  description = "(Deprecated) Configuration of S3 object locking."
  type = object({
    object_lock_enabled = optional(string)
    rule = optional(object({
      default_retention = object({
        mode  = string
        days  = optional(number)
        years = optional(number)
      })
    }))
  })
  default = null

  validation {
    condition = var.object_lock_configuration == null || (
      var.object_lock_configuration.object_lock_enabled == null ||
      var.object_lock_configuration.object_lock_enabled == "Enabled"
    )
    error_message = "resource_aws_s3_bucket, object_lock_configuration object_lock_enabled must be 'Enabled'."
  }

  validation {
    condition = var.object_lock_configuration == null || (
      var.object_lock_configuration.rule == null ||
      var.object_lock_configuration.rule.default_retention == null ||
      contains(["GOVERNANCE", "COMPLIANCE"], var.object_lock_configuration.rule.default_retention.mode)
    )
    error_message = "resource_aws_s3_bucket, object_lock_configuration rule default_retention mode must be either 'GOVERNANCE' or 'COMPLIANCE'."
  }

  validation {
    condition = var.object_lock_configuration == null || (
      var.object_lock_configuration.rule == null ||
      var.object_lock_configuration.rule.default_retention == null ||
      (var.object_lock_configuration.rule.default_retention.days == null) != (var.object_lock_configuration.rule.default_retention.years == null)
    )
    error_message = "resource_aws_s3_bucket, object_lock_configuration rule default_retention must specify either days or years, but not both."
  }
}

variable "policy" {
  description = "(Deprecated) Valid bucket policy JSON document."
  type        = string
  default     = null
}

variable "replication_configuration" {
  description = "(Deprecated) Configuration of replication configuration."
  type = object({
    role = string
    rules = list(object({
      delete_marker_replication_status = optional(string)
      id                               = optional(string)
      prefix                           = optional(string)
      priority                         = optional(number)
      status                           = string
      filter = optional(object({
        prefix = optional(string)
        tags   = optional(map(string))
      }))
      destination = object({
        bucket             = string
        storage_class      = optional(string)
        replica_kms_key_id = optional(string)
        account_id         = optional(string)
        access_control_translation = optional(object({
          owner = string
        }))
        replication_time = optional(object({
          status  = optional(string)
          minutes = optional(number)
        }))
        metrics = optional(object({
          status  = optional(string)
          minutes = optional(number)
        }))
      })
      source_selection_criteria = optional(object({
        sse_kms_encrypted_objects = optional(object({
          enabled = bool
        }))
      }))
    }))
  })
  default = null

  validation {
    condition = var.replication_configuration == null || alltrue([
      for rule in var.replication_configuration.rules : contains(["Enabled", "Disabled"], rule.status)
    ])
    error_message = "resource_aws_s3_bucket, replication_configuration rules status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = var.replication_configuration == null || alltrue([
      for rule in var.replication_configuration.rules : rule.id == null || length(rule.id) <= 255
    ])
    error_message = "resource_aws_s3_bucket, replication_configuration rules id must be less than or equal to 255 characters in length."
  }

  validation {
    condition = var.replication_configuration == null || alltrue([
      for rule in var.replication_configuration.rules : rule.prefix == null || length(rule.prefix) <= 1024
    ])
    error_message = "resource_aws_s3_bucket, replication_configuration rules prefix must be less than or equal to 1024 characters in length."
  }

  validation {
    condition = var.replication_configuration == null || alltrue([
      for rule in var.replication_configuration.rules :
      rule.delete_marker_replication_status == null || rule.delete_marker_replication_status == "Enabled"
    ])
    error_message = "resource_aws_s3_bucket, replication_configuration rules delete_marker_replication_status must be 'Enabled'."
  }

  validation {
    condition = var.replication_configuration == null || alltrue([
      for rule in var.replication_configuration.rules :
      rule.destination.access_control_translation == null ||
      rule.destination.access_control_translation.owner == "Destination"
    ])
    error_message = "resource_aws_s3_bucket, replication_configuration rules destination access_control_translation owner must be 'Destination'."
  }

  validation {
    condition = var.replication_configuration == null || alltrue([
      for rule in var.replication_configuration.rules :
      rule.destination.replication_time == null ||
      rule.destination.replication_time.status == null ||
      contains(["Enabled", "Disabled"], rule.destination.replication_time.status)
    ])
    error_message = "resource_aws_s3_bucket, replication_configuration rules destination replication_time status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = var.replication_configuration == null || alltrue([
      for rule in var.replication_configuration.rules :
      rule.destination.replication_time == null ||
      rule.destination.replication_time.minutes == null ||
      rule.destination.replication_time.minutes == 15
    ])
    error_message = "resource_aws_s3_bucket, replication_configuration rules destination replication_time minutes must be 15."
  }

  validation {
    condition = var.replication_configuration == null || alltrue([
      for rule in var.replication_configuration.rules :
      rule.destination.metrics == null ||
      rule.destination.metrics.status == null ||
      contains(["Enabled", "Disabled"], rule.destination.metrics.status)
    ])
    error_message = "resource_aws_s3_bucket, replication_configuration rules destination metrics status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = var.replication_configuration == null || alltrue([
      for rule in var.replication_configuration.rules :
      rule.destination.metrics == null ||
      rule.destination.metrics.minutes == null ||
      rule.destination.metrics.minutes == 15
    ])
    error_message = "resource_aws_s3_bucket, replication_configuration rules destination metrics minutes must be 15."
  }
}

variable "request_payer" {
  description = "(Deprecated) Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester."
  type        = string
  default     = null

  validation {
    condition     = var.request_payer == null || contains(["BucketOwner", "Requester"], var.request_payer)
    error_message = "resource_aws_s3_bucket, request_payer must be either 'BucketOwner' or 'Requester'."
  }
}

variable "server_side_encryption_configuration" {
  description = "(Deprecated) Configuration of server-side encryption configuration."
  type = object({
    rule = object({
      apply_server_side_encryption_by_default = object({
        sse_algorithm     = string
        kms_master_key_id = optional(string)
      })
      bucket_key_enabled = optional(bool)
    })
  })
  default = null

  validation {
    condition = var.server_side_encryption_configuration == null || contains(
      ["AES256", "aws:kms"],
      var.server_side_encryption_configuration.rule.apply_server_side_encryption_by_default.sse_algorithm
    )
    error_message = "resource_aws_s3_bucket, server_side_encryption_configuration rule apply_server_side_encryption_by_default sse_algorithm must be either 'AES256' or 'aws:kms'."
  }
}

variable "versioning" {
  description = "(Deprecated) Configuration of the S3 bucket versioning state."
  type = object({
    enabled    = optional(bool)
    mfa_delete = optional(bool)
  })
  default = null
}

variable "website" {
  description = "(Deprecated) Configuration of the S3 bucket website."
  type = object({
    index_document           = optional(string)
    error_document           = optional(string)
    redirect_all_requests_to = optional(string)
    routing_rules            = optional(string)
  })
  default = null
}

variable "timeouts" {
  description = "Timeouts configuration for the resource operations."
  type = object({
    create = optional(string, "20m")
    read   = optional(string, "20m")
    update = optional(string, "20m")
    delete = optional(string, "60m")
  })
  default = {
    create = "20m"
    read   = "20m"
    update = "20m"
    delete = "60m"
  }
}