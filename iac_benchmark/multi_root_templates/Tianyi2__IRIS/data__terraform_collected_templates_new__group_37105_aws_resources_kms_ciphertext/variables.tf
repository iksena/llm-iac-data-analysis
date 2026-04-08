variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_kms_ciphertext, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "plaintext" {
  description = "Data to be encrypted. Note that this may show up in logs, and it will be stored in the state file."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.plaintext) > 0
    error_message = "resource_aws_kms_ciphertext, plaintext cannot be empty."
  }
}

variable "key_id" {
  description = "Globally unique key ID for the customer master key."
  type        = string

  validation {
    condition     = length(var.key_id) > 0
    error_message = "resource_aws_kms_ciphertext, key_id cannot be empty."
  }
}

variable "context" {
  description = "An optional mapping that makes up the encryption context."
  type        = map(string)
  default     = null

  validation {
    condition     = var.context == null || alltrue([for k, v in var.context : can(regex("^[A-Za-z0-9/_:.-]+$", k)) && can(regex("^[A-Za-z0-9/_:.-]+$", v))])
    error_message = "resource_aws_kms_ciphertext, context keys and values must contain only alphanumeric characters, hyphens, underscores, periods, forward slashes, and colons."
  }
}