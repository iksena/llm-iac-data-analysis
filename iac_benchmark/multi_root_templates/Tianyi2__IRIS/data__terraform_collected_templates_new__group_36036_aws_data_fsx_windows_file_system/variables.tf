variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_fsx_windows_file_system, region must be a valid AWS region format or null."
  }
}

variable "id" {
  description = "Identifier of the file system (e.g. fs-12345678)."
  type        = string

  validation {
    condition     = can(regex("^fs-[a-f0-9]{8,17}$", var.id))
    error_message = "data_aws_fsx_windows_file_system, id must be a valid FSx file system identifier (e.g. fs-12345678)."
  }
}