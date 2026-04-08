variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "disk_id" {
  description = "Local disk identifier. For example, pci-0000:03:00.0-scsi-0:0:0:0."
  type        = string

  validation {
    condition     = can(regex("^pci-[0-9a-fA-F]{4}:[0-9a-fA-F]{2}:[0-9a-fA-F]{2}\\.[0-9a-fA-F]-scsi-[0-9]+:[0-9]+:[0-9]+:[0-9]+$", var.disk_id))
    error_message = "resource_aws_storagegateway_cache, disk_id must be a valid local disk identifier format (e.g., pci-0000:03:00.0-scsi-0:0:0:0)."
  }
}

variable "gateway_arn" {
  description = "The Amazon Resource Name (ARN) of the gateway."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:storagegateway:[a-z0-9-]+:[0-9]{12}:gateway/sgw-[a-zA-Z0-9]+$", var.gateway_arn))
    error_message = "resource_aws_storagegateway_cache, gateway_arn must be a valid Storage Gateway ARN format."
  }
}