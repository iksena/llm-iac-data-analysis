variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain" {
  description = "Name of the domain that is in scope for the generated authorization token."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.domain)) && length(var.domain) >= 2 && length(var.domain) <= 50
    error_message = "data_aws_codeartifact_authorization_token, domain must be between 2 and 50 characters, containing only lowercase letters, numbers, and hyphens."
  }
}

variable "domain_owner" {
  description = "Account number of the AWS account that owns the domain."
  type        = string
  default     = null

  validation {
    condition     = var.domain_owner == null || can(regex("^[0-9]{12}$", var.domain_owner))
    error_message = "data_aws_codeartifact_authorization_token, domain_owner must be a 12-digit AWS account number."
  }
}

variable "duration_seconds" {
  description = "Time, in seconds, that the generated authorization token is valid. Valid values are 0 and between 900 and 43200."
  type        = number
  default     = null

  validation {
    condition     = var.duration_seconds == null || var.duration_seconds == 0 || (var.duration_seconds >= 900 && var.duration_seconds <= 43200)
    error_message = "data_aws_codeartifact_authorization_token, duration_seconds must be 0 or between 900 and 43200 seconds."
  }
}