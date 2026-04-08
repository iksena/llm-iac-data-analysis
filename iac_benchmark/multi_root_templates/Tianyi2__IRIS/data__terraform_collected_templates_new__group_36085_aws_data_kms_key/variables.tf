variable "key_id" {
  description = "Key identifier which can be one of the following format: Key ID, Key ARN, Alias name, or Alias ARN"
  type        = string

  validation {
    condition     = length(var.key_id) > 0
    error_message = "data_aws_kms_key, key_id must not be empty."
  }
}

variable "grant_tokens" {
  description = "List of grant tokens"
  type        = list(string)
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}