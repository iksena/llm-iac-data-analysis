variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the snapshot."
  type        = string

  validation {
    condition     = var.name != null && length(var.name) > 0
    error_message = "data_aws_memorydb_snapshot, name must be a non-empty string."
  }
}