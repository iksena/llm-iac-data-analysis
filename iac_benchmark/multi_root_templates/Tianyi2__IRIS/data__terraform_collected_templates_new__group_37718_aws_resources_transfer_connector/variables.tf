variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "access_role" {
  description = "The IAM Role which provides read and write access to the parent directory of the file location mentioned in the StartFileTransfer request"
  type        = string
}

variable "url" {
  description = "The URL of the partners AS2 endpoint or SFTP endpoint"
  type        = string
}

variable "logging_role" {
  description = "The IAM Role which is required for allowing the connector to turn on CloudWatch logging for Amazon S3 events"
  type        = string
  default     = null
}

variable "security_policy_name" {
  description = "Name of the security policy for the connector"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "as2_config" {
  description = "The parameters to configure for the AS2 connector object"
  type = object({
    compression           = string
    encryption_algorithm  = string
    local_profile_id      = string
    mdn_response          = string
    mdn_signing_algorithm = optional(string)
    message_subject       = optional(string)
    partner_profile_id    = string
    signing_algorithm     = string
  })
  default = null

  validation {
    condition     = var.as2_config == null || contains(["ZLIB", "DISABLED"], var.as2_config.compression)
    error_message = "resource_aws_transfer_connector, compression must be one of: ZLIB, DISABLED."
  }

  validation {
    condition     = var.as2_config == null || contains(["AES128_CBC", "AES192_CBC", "AES256_CBC", "NONE"], var.as2_config.encryption_algorithm)
    error_message = "resource_aws_transfer_connector, encryption_algorithm must be one of: AES128_CBC, AES192_CBC, AES256_CBC, NONE."
  }

  validation {
    condition     = var.as2_config == null || contains(["SYNC", "NONE"], var.as2_config.mdn_response)
    error_message = "resource_aws_transfer_connector, mdn_response must be one of: SYNC, NONE."
  }

  validation {
    condition     = var.as2_config == null || var.as2_config.mdn_signing_algorithm == null || contains(["SHA256", "SHA384", "SHA512", "SHA1", "NONE", "DEFAULT"], var.as2_config.mdn_signing_algorithm)
    error_message = "resource_aws_transfer_connector, mdn_signing_algorithm must be one of: SHA256, SHA384, SHA512, SHA1, NONE, DEFAULT."
  }

  validation {
    condition     = var.as2_config == null || contains(["SHA256", "SHA384", "SHA512", "SHA1", "NONE"], var.as2_config.signing_algorithm)
    error_message = "resource_aws_transfer_connector, signing_algorithm must be one of: SHA256, SHA384, SHA512, SHA1, NONE."
  }
}

variable "sftp_config" {
  description = "The parameters to configure for the SFTP connector object"
  type = object({
    trusted_host_keys = list(string)
    user_secret_id    = string
  })
  default = null

  validation {
    condition     = var.sftp_config == null || length(var.sftp_config.trusted_host_keys) > 0
    error_message = "resource_aws_transfer_connector, trusted_host_keys must contain at least one key."
  }
}