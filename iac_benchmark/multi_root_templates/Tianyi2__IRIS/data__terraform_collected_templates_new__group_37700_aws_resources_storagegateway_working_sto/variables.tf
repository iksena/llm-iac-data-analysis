variable "disk_id" {
  type        = string
  description = "Local disk identifier. For example, `pci-0000:03:00.0-scsi-0:0:0:0`."

  validation {
    condition     = can(regex("^pci-[0-9a-f]+:[0-9a-f]+:[0-9a-f]+\\.[0-9]-scsi-[0-9]+:[0-9]+:[0-9]+:[0-9]+$", var.disk_id))
    error_message = "resource_aws_storagegateway_working_storage, disk_id must be in the format 'pci-xxxx:xx:xx.x-scsi-x:x:x:x'."
  }
}

variable "gateway_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the gateway."

  validation {
    condition     = can(regex("^arn:aws:storagegateway:[a-z0-9-]+:[0-9]{12}:gateway/sgw-[0-9a-f]{8}$", var.gateway_arn))
    error_message = "resource_aws_storagegateway_working_storage, gateway_arn must be a valid Storage Gateway ARN."
  }
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}