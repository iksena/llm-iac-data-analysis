variable "name" {
  description = "Name of the target signing profile"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_signer_signing_profile, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$|^[a-z]{2}-[a-z]+-[0-9]-[a-z]+$", var.region))
    error_message = "data_aws_signer_signing_profile, region must be a valid AWS region format."
  }
}