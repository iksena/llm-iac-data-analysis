variable "name" {
  type        = string
  description = "The name of the s3 bucket"
  default     = "benchmark-s3-bucket"
}

variable "use_prefix" {
  type        = bool
  description = "Use var.name as name prefix instead"
  default     = true
}

variable "name_override" {
  type        = bool
  description = "Name override the opinionated name variable"
  default     = false
}

variable "labels" {
  description = "Instance of labels module"

  type = object(
    {
      id   = string
      tags = any
    }
  )

  default = {
    id   = ""
    tags = {}
  }
}

variable "groups" {
  description = "Group names to attach"

  type = map(object({
    name = string
    mode = optional(string, "ro")
  }))

  validation {
    condition     = alltrue([for x in var.groups : x.mode == null || contains(["rw", "ro"], lower(x.mode))])
    error_message = "Mode must be `\"rw\"`,`\"ro\"`."
  }

  default = {}
}

variable "roles" {
  description = "Roles to attach"

  type = map(object({
    name = string
    mode = optional(string, "ro")
  }))

  validation {
    condition     = alltrue([for x in var.roles : x.mode == null || contains(["rw", "ro"], lower(x.mode))])
    error_message = "Mode must be `\"rw\"`,`\"ro\"`."
  }

  default = {}
}

variable "server_side_encryption_configuration" {
  description = <<EOT
  Pass through to server_side_encryption_configuration. If null is passed for kms_master_key_id, will autocreate.
  An alias can also be passed to be created on the key.
  EOT

  type = object({
    type              = string
    kms_master_key_id = optional(string)
    alias             = optional(string)
  })

  default = {
    alias             = null
    kms_master_key_id = null
    type              = "aws:kms"
  }
}

variable "acl" {
  description = "Canned ACL grant"
  type        = string
  default     = null
}

variable "enable_versioning" {
  description = "Use bucket versioning"
  type        = bool
  default     = true
}

variable "config_iam" {
  description = "Bucket IAM Configuration"

  type = object({
    enable        = optional(bool, true),
    bucket_policy = optional(string, "")
    policy_conditions = optional(map(list(object({
      test     = string
      variable = string
      values   = list(string)
    }))), {})
  })

  default = {
    enable = true
  }
}

variable "config_logging" {
  description = <<EOT
  Logging Configuration - List of objects with target bucket and key prefix(defaults to bucket resource ID)
  EOT

  type = object({
    enable = optional(bool),
    buckets = optional(map(object({
      target_bucket = string
      target_prefix = optional(string)
    })), {})
  })

  default = {
    enable = false
  }

  validation {
    condition     = var.config_logging.enable == false || length(var.config_logging.buckets) > 0
    error_message = "`config_logging` requires at least one bucket or `config_logging.enable` is set to false."
  }
}

variable "config_cors" {
  description = "CORS Configuration"
  type = object({
    rules = optional(list(object({
      allowed_headers = optional(list(string))
      allowed_methods = optional(list(string))
      allowed_origins = optional(list(string))
      expose_headers  = optional(list(string))
    })), [])
  })

  default = {}
}

variable "public_access_block" {
  description = "Public Access Block Configuration"

  type = object({
    block_public_policy     = optional(bool, true)
    block_public_acls       = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
  })

  default = {}
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Force Destroy S3 Bucket"
}
