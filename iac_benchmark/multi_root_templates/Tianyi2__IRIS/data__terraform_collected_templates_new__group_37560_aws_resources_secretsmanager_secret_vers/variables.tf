variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "secret_id" {
  description = "Specifies the secret to which you want to add a new version. You can specify either the Amazon Resource Name (ARN) or the friendly name of the secret. The secret must already exist."
  type        = string

  validation {
    condition     = length(var.secret_id) > 0
    error_message = "resource_aws_secretsmanager_secret_version, secret_id must not be empty."
  }
}

variable "secret_string" {
  description = "Specifies text data that you want to encrypt and store in this version of the secret. This is required if secret_binary or secret_string_wo is not set."
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_string_wo" {
  description = "Specifies text data that you want to encrypt and store in this version of the secret. This is required if secret_binary or secret_string is not set."
  type        = string
  default     = null
  sensitive   = true
}

variable "secret_string_wo_version" {
  description = "Used together with secret_string_wo to trigger an update. Increment this value when an update to secret_string_wo is required."
  type        = number
  default     = null

  validation {
    condition     = var.secret_string_wo_version == null || var.secret_string_wo_version >= 0
    error_message = "resource_aws_secretsmanager_secret_version, secret_string_wo_version must be a non-negative number."
  }
}

variable "secret_binary" {
  description = "Specifies binary data that you want to encrypt and store in this version of the secret. This is required if secret_string or secret_string_wo is not set. Needs to be encoded to base64."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.secret_binary == null || can(base64decode(var.secret_binary))
    error_message = "resource_aws_secretsmanager_secret_version, secret_binary must be valid base64 encoded data."
  }
}

variable "version_stages" {
  description = "Specifies a list of staging labels that are attached to this version of the secret. A staging label must be unique to a single version of the secret. If you specify a staging label that's already associated with a different version of the same secret then that staging label is automatically removed from the other version and attached to this version. If you do not specify a value, then AWS Secrets Manager automatically moves the staging label AWSCURRENT to this new version on creation."
  type        = list(string)
  default     = null

  validation {
    condition     = var.version_stages == null || length(var.version_stages) > 0
    error_message = "resource_aws_secretsmanager_secret_version, version_stages must contain at least one staging label when specified."
  }

  validation {
    condition     = var.version_stages == null || length(var.version_stages) == length(distinct(var.version_stages))
    error_message = "resource_aws_secretsmanager_secret_version, version_stages must contain unique staging labels."
  }
}