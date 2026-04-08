variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "acl" {
  description = "Specifies the Canned ACL to apply to the bucket. Valid values: private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, bucket-owner-full-control, log-delivery-write."
  type        = string
  default     = null

  validation {
    condition = var.acl == null || contains([
      "private",
      "public-read",
      "public-read-write",
      "aws-exec-read",
      "authenticated-read",
      "bucket-owner-read",
      "bucket-owner-full-control",
      "log-delivery-write"
    ], var.acl)
    error_message = "resource_aws_s3_bucket_acl, acl must be one of: private, public-read, public-read-write, aws-exec-read, authenticated-read, bucket-owner-read, bucket-owner-full-control, log-delivery-write."
  }
}

variable "bucket" {
  description = "Bucket to which to apply the ACL."
  type        = string

  validation {
    condition     = var.bucket != null && var.bucket != ""
    error_message = "resource_aws_s3_bucket_acl, bucket must be specified and cannot be empty."
  }
}

variable "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner."
  type        = string
  default     = null

  validation {
    condition     = var.expected_bucket_owner == null || can(regex("^[0-9]{12}$", var.expected_bucket_owner))
    error_message = "resource_aws_s3_bucket_acl, expected_bucket_owner must be a 12-digit AWS account ID."
  }
}

variable "access_control_policy" {
  description = "Configuration block that sets the ACL permissions for an object per grantee."
  type = object({
    grants = list(object({
      permission = string
      grantee = object({
        email_address = optional(string)
        id            = optional(string)
        type          = string
        uri           = optional(string)
      })
    }))
    owner = object({
      id           = string
      display_name = optional(string)
    })
  })
  default = null

  validation {
    condition = var.access_control_policy == null || (
      var.access_control_policy.grants != null &&
      length(var.access_control_policy.grants) > 0 &&
      var.access_control_policy.owner != null &&
      var.access_control_policy.owner.id != null &&
      var.access_control_policy.owner.id != ""
    )
    error_message = "resource_aws_s3_bucket_acl, access_control_policy must have at least one grant and owner.id must be specified."
  }

  validation {
    condition = var.access_control_policy == null || alltrue([
      for grant in var.access_control_policy.grants : contains([
        "FULL_CONTROL",
        "WRITE",
        "WRITE_ACP",
        "READ",
        "READ_ACP"
      ], grant.permission)
    ])
    error_message = "resource_aws_s3_bucket_acl, access_control_policy grant permission must be one of: FULL_CONTROL, WRITE, WRITE_ACP, READ, READ_ACP."
  }

  validation {
    condition = var.access_control_policy == null || alltrue([
      for grant in var.access_control_policy.grants : contains([
        "CanonicalUser",
        "AmazonCustomerByEmail",
        "Group"
      ], grant.grantee.type)
    ])
    error_message = "resource_aws_s3_bucket_acl, access_control_policy grantee type must be one of: CanonicalUser, AmazonCustomerByEmail, Group."
  }
}