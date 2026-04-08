variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "client_list" {
  description = "The list of clients that are allowed to access the file gateway. The list must contain either valid IP addresses or valid CIDR blocks. Set to [\"0.0.0.0/0\"] to not limit access. Minimum 1 item. Maximum 100 items."
  type        = list(string)

  validation {
    condition     = length(var.client_list) >= 1 && length(var.client_list) <= 100
    error_message = "resource_aws_storagegateway_nfs_file_share, client_list must contain between 1 and 100 items."
  }
}

variable "gateway_arn" {
  description = "Amazon Resource Name (ARN) of the file gateway."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:storagegateway:", var.gateway_arn))
    error_message = "resource_aws_storagegateway_nfs_file_share, gateway_arn must be a valid AWS Storage Gateway ARN."
  }
}

variable "location_arn" {
  description = "The ARN of the backed storage used for storing file data."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:", var.location_arn))
    error_message = "resource_aws_storagegateway_nfs_file_share, location_arn must be a valid AWS ARN."
  }
}

variable "role_arn" {
  description = "The ARN of the AWS Identity and Access Management (IAM) role that a file gateway assumes when it accesses the underlying storage."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam:", var.role_arn))
    error_message = "resource_aws_storagegateway_nfs_file_share, role_arn must be a valid AWS IAM role ARN."
  }
}

variable "vpc_endpoint_dns_name" {
  description = "The DNS name of the VPC endpoint for S3 PrivateLink."
  type        = string
  default     = null
}

variable "bucket_region" {
  description = "The region of the S3 bucket used by the file share. Required when specifying vpc_endpoint_dns_name."
  type        = string
  default     = null
}

variable "audit_destination_arn" {
  description = "The Amazon Resource Name (ARN) of the storage used for audit logs."
  type        = string
  default     = null

  validation {
    condition     = var.audit_destination_arn == null || can(regex("^arn:aws:", var.audit_destination_arn))
    error_message = "resource_aws_storagegateway_nfs_file_share, audit_destination_arn must be a valid AWS ARN when specified."
  }
}

variable "default_storage_class" {
  description = "The default storage class for objects put into an Amazon S3 bucket by the file gateway. Defaults to S3_STANDARD."
  type        = string
  default     = "S3_STANDARD"
}

variable "guess_mime_type_enabled" {
  description = "Boolean value that enables guessing of the MIME type for uploaded objects based on file extensions. Defaults to true."
  type        = bool
  default     = true
}

variable "kms_encrypted" {
  description = "Boolean value if true to use Amazon S3 server side encryption with your own AWS KMS key, or false to use a key managed by Amazon S3. Defaults to false."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "Amazon Resource Name (ARN) for KMS key used for Amazon S3 server side encryption. This value can only be set when kms_encrypted is true."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:", var.kms_key_arn))
    error_message = "resource_aws_storagegateway_nfs_file_share, kms_key_arn must be a valid AWS KMS key ARN when specified."
  }
}

variable "object_acl" {
  description = "Access Control List permission for S3 objects. Defaults to private."
  type        = string
  default     = "private"
}

variable "read_only" {
  description = "Boolean to indicate write status of file share. File share does not accept writes if true. Defaults to false."
  type        = bool
  default     = false
}

variable "requester_pays" {
  description = "Boolean who pays the cost of the request and the data download from the Amazon S3 bucket. Set this value to true if you want the requester to pay instead of the bucket owner. Defaults to false."
  type        = bool
  default     = false
}

variable "squash" {
  description = "Maps a user to anonymous user. Defaults to RootSquash. Valid values: RootSquash (only root is mapped to anonymous user), NoSquash (no one is mapped to anonymous user), AllSquash (everyone is mapped to anonymous user)"
  type        = string
  default     = "RootSquash"

  validation {
    condition     = contains(["RootSquash", "NoSquash", "AllSquash"], var.squash)
    error_message = "resource_aws_storagegateway_nfs_file_share, squash must be one of: RootSquash, NoSquash, or AllSquash."
  }
}

variable "file_share_name" {
  description = "The name of the file share. Must be set if an S3 prefix name is set in location_arn."
  type        = string
  default     = null
}

variable "notification_policy" {
  description = "The notification policy of the file share. Default value is {}."
  type        = string
  default     = "{}"
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "nfs_file_share_defaults" {
  description = "Files and folders stored as Amazon S3 objects in S3 buckets don't, by default, have Unix file permissions assigned to them."
  type = object({
    directory_mode = optional(string, "0777")
    file_mode      = optional(string, "0666")
    group_id       = optional(number, 65534)
    owner_id       = optional(number, 65534)
  })
  default = null

  validation {
    condition = var.nfs_file_share_defaults == null || (
      var.nfs_file_share_defaults.group_id >= 0 &&
      var.nfs_file_share_defaults.group_id <= 4294967294 &&
      var.nfs_file_share_defaults.owner_id >= 0 &&
      var.nfs_file_share_defaults.owner_id <= 4294967294
    )
    error_message = "resource_aws_storagegateway_nfs_file_share, nfs_file_share_defaults group_id and owner_id must be between 0 and 4294967294."
  }
}

variable "cache_attributes" {
  description = "Refresh cache information."
  type = object({
    cache_stale_timeout_in_seconds = optional(number)
  })
  default = null

  validation {
    condition = var.cache_attributes == null || (
      var.cache_attributes.cache_stale_timeout_in_seconds == null ||
      (var.cache_attributes.cache_stale_timeout_in_seconds >= 300 &&
      var.cache_attributes.cache_stale_timeout_in_seconds <= 2592000)
    )
    error_message = "resource_aws_storagegateway_nfs_file_share, cache_attributes cache_stale_timeout_in_seconds must be between 300 and 2592000 seconds (5 minutes to 30 days)."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the NFS file share"
  type        = string
  default     = "10m"
}

variable "timeouts_update" {
  description = "Timeout for updating the NFS file share"
  type        = string
  default     = "10m"
}

variable "timeouts_delete" {
  description = "Timeout for deleting the NFS file share"
  type        = string
  default     = "10m"
}