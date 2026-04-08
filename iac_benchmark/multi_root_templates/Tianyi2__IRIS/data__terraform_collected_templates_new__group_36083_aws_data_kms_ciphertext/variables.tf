variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "plaintext" {
  description = "Data to be encrypted. Note that this may show up in logs, and it will be stored in the state file."
  type        = string
  sensitive   = true

  validation {
    condition     = var.plaintext != null && var.plaintext != ""
    error_message = "data_aws_kms_ciphertext, plaintext must be provided and cannot be empty."
  }
}

variable "key_id" {
  description = "Globally unique key ID for the customer master key."
  type        = string

  validation {
    condition     = var.key_id != null && var.key_id != ""
    error_message = "data_aws_kms_ciphertext, key_id must be provided and cannot be empty."
  }
}

variable "context" {
  description = "An optional mapping that makes up the encryption context."
  type        = map(string)
  default     = null
}