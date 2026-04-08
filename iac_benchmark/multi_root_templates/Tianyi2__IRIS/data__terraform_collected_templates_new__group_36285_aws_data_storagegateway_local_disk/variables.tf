variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "gateway_arn" {
  description = "ARN of the gateway."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:storagegateway:", var.gateway_arn))
    error_message = "data_aws_storagegateway_local_disk, gateway_arn must be a valid Storage Gateway ARN starting with 'arn:aws:storagegateway:'."
  }
}

variable "disk_node" {
  description = "Device node of the local disk to retrieve. For example, /dev/sdb."
  type        = string
  default     = null

  validation {
    condition     = var.disk_node == null || can(regex("^/dev/", var.disk_node))
    error_message = "data_aws_storagegateway_local_disk, disk_node must start with '/dev/' when specified."
  }
}

variable "disk_path" {
  description = "Device path of the local disk to retrieve. For example, /dev/xvdb or /dev/nvme1n1."
  type        = string
  default     = null

  validation {
    condition     = var.disk_path == null || can(regex("^/dev/", var.disk_path))
    error_message = "data_aws_storagegateway_local_disk, disk_path must start with '/dev/' when specified."
  }
}