variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "gateway_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the gateway."

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:storagegateway:[a-z0-9-]+:[0-9]{12}:gateway/sgw-[0-9a-fA-F]{8}$", var.gateway_arn))
    error_message = "resource_aws_storagegateway_file_system_association, gateway_arn must be a valid Storage Gateway ARN."
  }
}

variable "location_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the Amazon FSx file system to associate with the FSx File Gateway."

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:fsx:[a-z0-9-]+:[0-9]{12}:file-system/fs-[0-9a-fA-F]{17}$", var.location_arn))
    error_message = "resource_aws_storagegateway_file_system_association, location_arn must be a valid FSx file system ARN."
  }
}

variable "username" {
  type        = string
  description = "The user name of the user credential that has permission to access the root share of the Amazon FSx file system. The user account must belong to the Amazon FSx delegated admin user group."

  validation {
    condition     = length(var.username) > 0 && length(var.username) <= 256
    error_message = "resource_aws_storagegateway_file_system_association, username must be between 1 and 256 characters."
  }
}

variable "password" {
  type        = string
  description = "The password of the user credential."
  sensitive   = true

  validation {
    condition     = length(var.password) > 0 && length(var.password) <= 512
    error_message = "resource_aws_storagegateway_file_system_association, password must be between 1 and 512 characters."
  }
}

variable "audit_destination_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the storage used for the audit logs."
  default     = null

  validation {
    condition     = var.audit_destination_arn == null || can(regex("^arn:aws[a-zA-Z-]*:(s3|logs):[a-z0-9-]*:[0-9]{12}:.+", var.audit_destination_arn))
    error_message = "resource_aws_storagegateway_file_system_association, audit_destination_arn must be a valid S3 bucket or CloudWatch log group ARN."
  }
}

variable "cache_attributes" {
  type = object({
    cache_stale_timeout_in_seconds = optional(number)
  })
  description = "Refresh cache information."
  default     = null

  validation {
    condition     = var.cache_attributes == null || var.cache_attributes.cache_stale_timeout_in_seconds == null || var.cache_attributes.cache_stale_timeout_in_seconds == 0 || (var.cache_attributes.cache_stale_timeout_in_seconds >= 300 && var.cache_attributes.cache_stale_timeout_in_seconds <= 2592000)
    error_message = "resource_aws_storagegateway_file_system_association, cache_stale_timeout_in_seconds must be 0 or between 300 and 2592000 seconds (5 minutes to 30 days)."
  }
}

variable "tags" {
  type        = map(string)
  description = "Key-value map of resource tags."
  default     = {}
}

variable "create_timeout" {
  type        = string
  description = "Timeout for creating the file system association."
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mh]$", var.create_timeout))
    error_message = "resource_aws_storagegateway_file_system_association, create_timeout must be in format like '30m' or '1h'."
  }
}

variable "update_timeout" {
  type        = string
  description = "Timeout for updating the file system association."
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mh]$", var.update_timeout))
    error_message = "resource_aws_storagegateway_file_system_association, update_timeout must be in format like '30m' or '1h'."
  }
}

variable "delete_timeout" {
  type        = string
  description = "Timeout for deleting the file system association."
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mh]$", var.delete_timeout))
    error_message = "resource_aws_storagegateway_file_system_association, delete_timeout must be in format like '30m' or '1h'."
  }
}