variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "repository_name" {
  description = "Name for the repository. This needs to be less than 100 characters."
  type        = string

  validation {
    condition     = length(var.repository_name) < 100
    error_message = "data_aws_codecommit_repository, repository_name must be less than 100 characters."
  }
}