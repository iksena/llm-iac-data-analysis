variable "alias_name" {
  description = "Name of the Key Alias."
  type        = string

  validation {
    condition     = var.alias_name != null && var.alias_name != ""
    error_message = "resource_aws_paymentcryptography_key_alias, alias_name cannot be null or empty."
  }
}

variable "key_arn" {
  description = "ARN of the key."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}