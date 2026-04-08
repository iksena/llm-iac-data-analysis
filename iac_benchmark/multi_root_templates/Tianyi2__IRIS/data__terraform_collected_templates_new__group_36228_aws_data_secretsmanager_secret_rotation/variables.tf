variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "secret_id" {
  description = "Specifies the secret containing the version that you want to retrieve. You can specify either the ARN or the friendly name of the secret."
  type        = string

  validation {
    condition     = length(var.secret_id) > 0
    error_message = "data_aws_secretsmanager_secret_rotation, secret_id cannot be empty."
  }
}