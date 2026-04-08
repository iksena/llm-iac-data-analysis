variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "auto_enable" {
  description = "Whether to enable Amazon Macie automatically for accounts that are added to the organization in AWS Organizations."
  type        = bool

  validation {
    condition     = var.auto_enable != null
    error_message = "resource_aws_macie2_organization_configuration, auto_enable is required."
  }
}