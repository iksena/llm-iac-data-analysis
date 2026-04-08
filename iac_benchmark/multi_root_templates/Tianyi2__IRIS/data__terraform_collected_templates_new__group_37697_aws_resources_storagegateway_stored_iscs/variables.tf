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
    error_message = "resource_aws_storagegateway_stored_iscsi_volume, gateway_arn must be a valid Storage Gateway ARN starting with 'arn:aws:storagegateway:'."
  }
}

variable "network_interface_id" {
  description = "The network interface of the gateway on which to expose the iSCSI target. Only IPv4 addresses are accepted."
  type        = string

  validation {
    condition     = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.network_interface_id))
    error_message = "resource_aws_storagegateway_stored_iscsi_volume, network_interface_id must be a valid IPv4 address."
  }
}

variable "target_name" {
  description = "The name of the iSCSI target used by initiators to connect to the target and as a suffix for the target ARN. The target name must be unique across all volumes of a gateway."
  type        = string

  validation {
    condition     = length(var.target_name) > 0 && length(var.target_name) <= 200
    error_message = "resource_aws_storagegateway_stored_iscsi_volume, target_name must be between 1 and 200 characters long."
  }
}

variable "disk_id" {
  description = "The unique identifier for the gateway local disk that is configured as a stored volume."
  type        = string

  validation {
    condition     = length(var.disk_id) > 0
    error_message = "resource_aws_storagegateway_stored_iscsi_volume, disk_id cannot be empty."
  }
}

variable "preserve_existing_data" {
  description = "Specify this field as true if you want to preserve the data on the local disk. Otherwise, specifying this field as false creates an empty volume."
  type        = bool
}

variable "snapshot_id" {
  description = "The snapshot ID of the snapshot to restore as the new stored volume. E.g., snap-1122aabb."
  type        = string
  default     = null

  validation {
    condition     = var.snapshot_id == null || can(regex("^snap-[0-9a-f]{8,17}$", var.snapshot_id))
    error_message = "resource_aws_storagegateway_stored_iscsi_volume, snapshot_id must be a valid snapshot ID starting with 'snap-' followed by 8-17 hexadecimal characters."
  }
}

variable "kms_encrypted" {
  description = "true to use Amazon S3 server side encryption with your own AWS KMS key, or false to use a key managed by Amazon S3."
  type        = bool
  default     = null
}

variable "kms_key" {
  description = "The Amazon Resource Name (ARN) of the AWS KMS key used for Amazon S3 server side encryption. This value can only be set when kms_encrypted is true."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key == null || can(regex("^arn:aws:kms:", var.kms_key))
    error_message = "resource_aws_storagegateway_stored_iscsi_volume, kms_key must be a valid KMS key ARN starting with 'arn:aws:kms:'."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}