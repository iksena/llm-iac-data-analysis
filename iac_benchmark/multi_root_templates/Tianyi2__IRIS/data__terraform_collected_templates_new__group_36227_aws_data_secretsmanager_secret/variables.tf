variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "ARN of the secret to retrieve."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the secret to retrieve."
  type        = string
  default     = null

  validation {
    condition     = var.arn != null || var.name != null
    error_message = "data_aws_secretsmanager_secret, arn or name must be provided."
  }
}