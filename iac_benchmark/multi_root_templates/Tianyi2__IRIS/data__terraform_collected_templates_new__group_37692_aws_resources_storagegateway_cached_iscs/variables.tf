variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "gateway_arn" {
  description = "The Amazon Resource Name (ARN) of the gateway."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:storagegateway:", var.gateway_arn))
    error_message = "resource_aws_storagegateway_cached_iscsi_volume, gateway_arn must be a valid Storage Gateway ARN starting with 'arn:aws:storagegateway:'."
  }
}

variable "network_interface_id" {
  description = "The network interface of the gateway on which to expose the iSCSI target. Only IPv4 addresses are accepted."
  type        = string

  validation {
    condition     = var.network_interface_id != ""
    error_message = "resource_aws_storagegateway_cached_iscsi_volume, network_interface_id cannot be empty."
  }
}

variable "target_name" {
  description = "The name of the iSCSI target used by initiators to connect to the target and as a suffix for the target ARN. The target name must be unique across all volumes of a gateway."
  type        = string

  validation {
    condition     = var.target_name != ""
    error_message = "resource_aws_storagegateway_cached_iscsi_volume, target_name cannot be empty."
  }

  validation {
    condition     = length(var.target_name) >= 1 && length(var.target_name) <= 200
    error_message = "resource_aws_storagegateway_cached_iscsi_volume, target_name must be between 1 and 200 characters."
  }
}

variable "volume_size_in_bytes" {
  description = "The size of the volume in bytes."
  type        = number

  validation {
    condition     = var.volume_size_in_bytes > 0
    error_message = "resource_aws_storagegateway_cached_iscsi_volume, volume_size_in_bytes must be greater than 0."
  }
}

variable "snapshot_id" {
  description = "The snapshot ID of the snapshot to restore as the new cached volume. E.g., snap-1122aabb."
  type        = string
  default     = null

  validation {
    condition     = var.snapshot_id == null || can(regex("^snap-[0-9a-f]{8}([0-9a-f]{9})?$", var.snapshot_id))
    error_message = "resource_aws_storagegateway_cached_iscsi_volume, snapshot_id must be a valid snapshot ID format (snap-xxxxxxxx or snap-xxxxxxxxxxxxxxxxx) or null."
  }
}

variable "source_volume_arn" {
  description = "The ARN for an existing volume. Specifying this ARN makes the new volume into an exact copy of the specified existing volume's latest recovery point. The volume_size_in_bytes value for this new volume must be equal to or larger than the size of the existing volume, in bytes."
  type        = string
  default     = null

  validation {
    condition     = var.source_volume_arn == null || can(regex("^arn:aws:storagegateway:", var.source_volume_arn))
    error_message = "resource_aws_storagegateway_cached_iscsi_volume, source_volume_arn must be a valid Storage Gateway volume ARN starting with 'arn:aws:storagegateway:' or null."
  }
}

variable "kms_encrypted" {
  description = "Set to true to use Amazon S3 server side encryption with your own AWS KMS key, or false to use a key managed by Amazon S3."
  type        = bool
  default     = null
}

variable "kms_key" {
  description = "The Amazon Resource Name (ARN) of the AWS KMS key used for Amazon S3 server side encryption. Is required when kms_encrypted is set."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key == null || can(regex("^arn:aws:kms:", var.kms_key))
    error_message = "resource_aws_storagegateway_cached_iscsi_volume, kms_key must be a valid KMS key ARN starting with 'arn:aws:kms:' or null."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}