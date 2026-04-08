variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "api_id" {
  type        = string
  description = "ID of the associated AppSync API"

  validation {
    condition     = length(var.api_id) > 0
    error_message = "resource_aws_appsync_api_key, api_id must be a non-empty string."
  }
}

variable "description" {
  type        = string
  description = "API key description. Defaults to 'Managed by Terraform'."
  default     = "Managed by Terraform"
}

variable "expires" {
  type        = string
  description = "RFC3339 string representation of the expiry date. Rounded down to nearest hour. By default, it is 7 days from the date of creation."
  default     = null

  validation {
    condition     = var.expires == null || can(formatdate("2006-01-02T15:04:05Z07:00", var.expires))
    error_message = "resource_aws_appsync_api_key, expires must be a valid RFC3339 timestamp format."
  }
}