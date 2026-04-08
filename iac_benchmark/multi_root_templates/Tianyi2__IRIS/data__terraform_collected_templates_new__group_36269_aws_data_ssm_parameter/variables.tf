variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ssm_parameter, region must be a valid AWS region identifier or null."
  }
}

variable "name" {
  description = "Name of the parameter."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_ssm_parameter, name cannot be empty."
  }
}

variable "with_decryption" {
  description = "Whether to return decrypted SecureString value. Defaults to true."
  type        = bool
  default     = true
}