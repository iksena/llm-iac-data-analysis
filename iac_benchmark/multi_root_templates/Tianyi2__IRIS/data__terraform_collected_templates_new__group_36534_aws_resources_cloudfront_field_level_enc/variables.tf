variable "name" {
  type        = string
  description = "The name of the Field Level Encryption Profile."

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_cloudfront_field_level_encryption_profile, name must not be empty."
  }
}

variable "comment" {
  type        = string
  description = "An optional comment about the Field Level Encryption Profile."
  default     = null
}

variable "public_key_id" {
  type        = string
  description = "The public key associated with a set of field-level encryption patterns, to be used when encrypting the fields that match the patterns."

  validation {
    condition     = length(var.public_key_id) > 0
    error_message = "resource_aws_cloudfront_field_level_encryption_profile, public_key_id must not be empty."
  }
}

variable "provider_id" {
  type        = string
  description = "The provider associated with the public key being used for encryption."

  validation {
    condition     = length(var.provider_id) > 0
    error_message = "resource_aws_cloudfront_field_level_encryption_profile, provider_id must not be empty."
  }
}

variable "field_pattern_items" {
  type        = list(string)
  description = "List of field patterns in a field-level encryption content type profile that specify the fields that you want to be encrypted."

  validation {
    condition     = length(var.field_pattern_items) > 0
    error_message = "resource_aws_cloudfront_field_level_encryption_profile, field_pattern_items must contain at least one item."
  }
}