variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "id" {
  type        = string
  description = "Identifier of the file system (e.g. fs-12345678)."

  validation {
    condition     = can(regex("^fs-[a-f0-9]{8,17}$", var.id))
    error_message = "data_aws_fsx_ontap_file_system, id must be a valid FSx file system identifier (e.g., fs-12345678)."
  }
}