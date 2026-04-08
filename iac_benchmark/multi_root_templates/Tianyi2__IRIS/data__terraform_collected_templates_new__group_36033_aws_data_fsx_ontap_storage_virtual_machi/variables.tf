variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_fsx_ontap_storage_virtual_machine, region must be a valid AWS region format."
  }
}

variable "id" {
  description = "Identifier of the storage virtual machine (e.g. svm-12345678)."
  type        = string
  default     = null

  validation {
    condition     = var.id == null || can(regex("^svm-[a-f0-9]{8}$", var.id))
    error_message = "data_aws_fsx_ontap_storage_virtual_machine, id must be in the format 'svm-' followed by 8 hexadecimal characters."
  }
}

variable "filter" {
  description = "Configuration block for complex filters."
  type = object({
    name   = string
    values = list(string)
  })
  default = null

  validation {
    condition     = var.filter == null || (var.filter.name != null && length(var.filter.values) > 0)
    error_message = "data_aws_fsx_ontap_storage_virtual_machine, filter must have a non-null name and at least one value."
  }
}