variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "license_configuration_arn" {
  description = "ARN of the license configuration."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:license-manager:", var.license_configuration_arn))
    error_message = "resource_aws_licensemanager_association, license_configuration_arn must be a valid License Manager configuration ARN starting with 'arn:aws:license-manager:'."
  }
}

variable "resource_arn" {
  description = "ARN of the resource associated with the license configuration."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:", var.resource_arn))
    error_message = "resource_aws_licensemanager_association, resource_arn must be a valid AWS resource ARN starting with 'arn:aws:'."
  }
}