variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "secret_id" {
  description = "Specifies the secret containing the version that you want to retrieve. You can specify either the ARN or the friendly name of the secret."
  type        = string

  validation {
    condition     = can(regex("^(arn:aws:secretsmanager:[a-z0-9-]+:[0-9]{12}:secret:[a-zA-Z0-9/_+=.@-]+|[a-zA-Z0-9/_+=.@-]+)$", var.secret_id))
    error_message = "data_aws_secretsmanager_secret_version, secret_id must be either an ARN or a friendly name of the secret."
  }
}

variable "version_id" {
  description = "Specifies the unique identifier of the version of the secret that you want to retrieve. Overrides version_stage."
  type        = string
  default     = null

  validation {
    condition     = var.version_id == null || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.version_id))
    error_message = "data_aws_secretsmanager_secret_version, version_id must be a valid UUID format."
  }
}

variable "version_stage" {
  description = "Specifies the secret version that you want to retrieve by the staging label attached to the version. Defaults to AWSCURRENT."
  type        = string
  default     = "AWSCURRENT"

  validation {
    condition     = can(regex("^[a-zA-Z0-9/_+=.@-]+$", var.version_stage))
    error_message = "data_aws_secretsmanager_secret_version, version_stage must contain only alphanumeric characters and the characters /_+=.@-."
  }
}