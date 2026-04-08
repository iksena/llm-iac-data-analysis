variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "prefix" {
  description = "The repository name prefix that the template matches against."
  type        = string

  validation {
    condition     = length(var.prefix) > 0
    error_message = "data_aws_ecr_repository_creation_template, prefix must be a non-empty string."
  }
}