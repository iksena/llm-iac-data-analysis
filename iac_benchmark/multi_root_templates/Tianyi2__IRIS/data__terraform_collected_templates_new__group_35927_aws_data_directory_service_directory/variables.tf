variable "directory_id" {
  description = "ID of the directory"
  type        = string

  validation {
    condition     = length(var.directory_id) > 0
    error_message = "data_aws_directory_service_directory, directory_id must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_directory_service_directory, region must be a valid AWS region format or null."
  }
}