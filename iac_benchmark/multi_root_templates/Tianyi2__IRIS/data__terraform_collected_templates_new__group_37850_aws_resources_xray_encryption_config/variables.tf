variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "type" {
  description = "The type of encryption. Set to KMS to use your own key for encryption. Set to NONE for default encryption."
  type        = string

  validation {
    condition     = contains(["KMS", "NONE"], var.type)
    error_message = "resource_aws_xray_encryption_config, type must be either 'KMS' or 'NONE'."
  }
}

variable "key_id" {
  description = "An AWS KMS customer master key (CMK) ARN."
  type        = string
  default     = null

  validation {
    condition     = var.key_id == null || can(regex("^arn:aws:kms:", var.key_id))
    error_message = "resource_aws_xray_encryption_config, key_id must be a valid KMS ARN starting with 'arn:aws:kms:'."
  }
}