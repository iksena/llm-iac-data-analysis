variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "disk_id" {
  description = "Local disk identifier. For example, `pci-0000:03:00.0-scsi-0:0:0:0`."
  type        = string
  default     = null

  validation {
    condition     = var.disk_id == null || can(regex("^[a-zA-Z0-9:.-]+$", var.disk_id))
    error_message = "resource_aws_storagegateway_upload_buffer, disk_id must be a valid disk identifier format."
  }
}

variable "disk_path" {
  description = "Local disk path. For example, `/dev/nvme1n1`."
  type        = string
  default     = null

  validation {
    condition     = var.disk_path == null || can(regex("^/.*", var.disk_path))
    error_message = "resource_aws_storagegateway_upload_buffer, disk_path must be a valid absolute path starting with '/'."
  }
}

variable "gateway_arn" {
  description = "The Amazon Resource Name (ARN) of the gateway."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:storagegateway:[a-z0-9-]+:[0-9]+:gateway/sgw-[a-z0-9]+$", var.gateway_arn))
    error_message = "resource_aws_storagegateway_upload_buffer, gateway_arn must be a valid Storage Gateway ARN."
  }
}

