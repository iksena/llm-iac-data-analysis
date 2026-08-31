variable "create" {
  description = "Determines if resources are created."
  default     = true
  type        = bool
}

variable "name" {
  description = "Name to use on created resources"
  type        = string
  default     = "benchmark"
}

variable "path" {
  description = "Path to use when creating IAM policies and IAM users"
  default     = "/"
  type        = string
}

variable "acl" {
  description = "Canned ACL applied to the bucket. Conflicts with enable_cloudfront_access."
  default     = "private"
  type        = string
}

variable "ownership" {
  description = "Object ownership. Valid values: BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced"
  default     = "BucketOwnerPreferred"
  type        = string
}

variable "versioning" {
  default = false
  type    = bool
}

variable "force_destroy" {
  default = false
  type    = bool
}

variable "block_public_acls" {
  default = true
  type    = bool
}

variable "block_public_policy" {
  default = true
  type    = bool
}

variable "restrict_public_buckets" {
  default = true
  type    = bool
}

variable "ignore_public_acls" {
  default = true
  type    = bool
}

variable "create_ro_user" {
  default = false
  type    = bool
}

variable "ro_user_name" {
  description = "Name of the read-only user. Default is {var.name}-ro."
  default     = null
  type        = string
}

variable "create_rw_user" {
  default = false
  type    = bool
}

variable "rw_user_name" {
  description = "Name of the read-write user. Default is {var.name}-rw."
  default     = null
  type        = string
}

variable "enable_cloudfront_access" {
  default = false
  type    = bool
}

variable "expiration_days" {
  default = -1
  type    = number
}

variable "version_expiration_days" {
  default = -1
  type    = number
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "s3_tags" {
  description = "A map of tags to add to the s3 bucket."
  type        = map(string)
  default     = {}
}

variable "rw_user_tags" {
  description = "A map of tags to add to the read-write IAM user."
  type        = map(string)
  default     = {}
}

variable "ro_user_tags" {
  description = "A map of tags to add to the read-only IAM user."
  type        = map(string)
  default     = {}
}

variable "kms_master_key_id" {
  description = "Optional AWS KMS master key ID to use for SSE-KMS encryption"
  type        = string
  default     = null
}

variable "create_bucket_notification_topic" {
  description = "Creates a SNS topic to receive bucket notifications"
  type        = bool
  default     = false
}
