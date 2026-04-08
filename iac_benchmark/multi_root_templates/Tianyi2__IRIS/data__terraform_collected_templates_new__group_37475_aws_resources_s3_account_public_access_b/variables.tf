variable "account_id" {
  description = "AWS account ID to configure. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.account_id == null || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_s3_account_public_access_block, account_id must be a 12-digit AWS account ID or null."
  }
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for buckets in this account. Defaults to false. Enabling this setting does not affect existing policies or ACLs. When set to true causes the following behavior: PUT Bucket acl and PUT Object acl calls will fail if the specified ACL allows public access. PUT Object calls fail if the request includes a public ACL."
  type        = bool
  default     = false

  validation {
    condition     = can(tobool(var.block_public_acls))
    error_message = "resource_aws_s3_account_public_access_block, block_public_acls must be a boolean value."
  }
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for buckets in this account. Defaults to false. Enabling this setting does not affect existing bucket policies. When set to true causes Amazon S3 to: Reject calls to PUT Bucket policy if the specified bucket policy allows public access."
  type        = bool
  default     = false

  validation {
    condition     = can(tobool(var.block_public_policy))
    error_message = "resource_aws_s3_account_public_access_block, block_public_policy must be a boolean value."
  }
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for buckets in this account. Defaults to false. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set. When set to true causes Amazon S3 to: Ignore all public ACLs on buckets in this account and any objects that they contain."
  type        = bool
  default     = false

  validation {
    condition     = can(tobool(var.ignore_public_acls))
    error_message = "resource_aws_s3_account_public_access_block, ignore_public_acls must be a boolean value."
  }
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for buckets in this account. Defaults to false. Enabling this setting does not affect previously stored bucket policies, except that public and cross-account access within any public bucket policy, including non-public delegation to specific accounts, is blocked. When set to true: Only the bucket owner and AWS Services can access buckets with public policies."
  type        = bool
  default     = false

  validation {
    condition     = can(tobool(var.restrict_public_buckets))
    error_message = "resource_aws_s3_account_public_access_block, restrict_public_buckets must be a boolean value."
  }
}