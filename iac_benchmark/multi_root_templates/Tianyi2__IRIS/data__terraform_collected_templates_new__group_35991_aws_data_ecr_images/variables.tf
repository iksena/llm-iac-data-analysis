variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "registry_id" {
  description = "ID of the Registry where the repository resides."
  type        = string
  default     = null
}

variable "repository_name" {
  description = "Name of the ECR Repository."
  type        = string

  validation {
    condition     = var.repository_name != null && var.repository_name != ""
    error_message = "data_aws_ecr_images, repository_name must be provided and cannot be empty."
  }
}