variable "data_protection_settings_arn" {
  description = "ARN of the data protection settings to associate with the portal. Forces replacement if changed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:", var.data_protection_settings_arn))
    error_message = "resource_aws_workspacesweb_data_protection_settings_association, data_protection_settings_arn must be a valid WorkSpaces Web ARN starting with 'arn:aws:workspaces-web:'."
  }
}

variable "portal_arn" {
  description = "ARN of the portal to associate with the data protection settings. Forces replacement if changed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:", var.portal_arn))
    error_message = "resource_aws_workspacesweb_data_protection_settings_association, portal_arn must be a valid WorkSpaces Web ARN starting with 'arn:aws:workspaces-web:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}