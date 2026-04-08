variable "name" {
  description = "Name of the ECR Repository"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_ecr_repository, name must not be empty."
  }
}

variable "registry_id" {
  description = "Registry ID where the repository was created"
  type        = string
  default     = null

  validation {
    condition     = var.registry_id == null || can(regex("^[0-9]{12}$", var.registry_id))
    error_message = "data_aws_ecr_repository, registry_id must be a valid 12-digit AWS account ID or null."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ecr_repository, region must be a valid AWS region format or null."
  }
}