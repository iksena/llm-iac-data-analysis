variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "license_arn" {
  description = "The ARN of the received license you want data for."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:license-manager:[a-z0-9-]*:[0-9]{12}:license:l-[a-f0-9]+$", var.license_arn))
    error_message = "data_aws_licensemanager_received_license, license_arn must be a valid License Manager license ARN in the format 'arn:aws:license-manager:region:account:license:l-licenseId'."
  }
}