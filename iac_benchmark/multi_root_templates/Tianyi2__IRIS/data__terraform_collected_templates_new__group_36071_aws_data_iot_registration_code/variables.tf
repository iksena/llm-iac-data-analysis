variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9][a-z0-9\\-]*[a-z0-9]$", var.region))
    error_message = "data_aws_iot_registration_code, region must be a valid AWS region format."
  }
}