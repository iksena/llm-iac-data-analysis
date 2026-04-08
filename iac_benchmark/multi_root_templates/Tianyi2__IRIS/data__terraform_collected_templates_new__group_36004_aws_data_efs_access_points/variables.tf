variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "file_system_id" {
  description = "EFS File System identifier."
  type        = string

  validation {
    condition     = can(regex("^fs-[0-9a-f]{8,40}$", var.file_system_id))
    error_message = "data_aws_efs_access_points, file_system_id must be a valid EFS file system ID (e.g., fs-12345678)."
  }
}