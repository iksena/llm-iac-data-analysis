variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "shared_directory_id" {
  description = "Identifier of the directory that is stored in the directory consumer account that corresponds to the shared directory in the owner account."
  type        = string

  validation {
    condition     = can(regex("^d-[0-9a-f]{10}$", var.shared_directory_id))
    error_message = "resource_aws_directory_service_shared_directory_accepter, shared_directory_id must be a valid directory ID format (d-xxxxxxxxxx)."
  }
}