variable "user_settings_arn" {
  description = "ARN of the user settings to associate with the portal. Forces replacement if changed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:", var.user_settings_arn))
    error_message = "resource_aws_workspacesweb_user_settings_association, user_settings_arn must be a valid WorkSpaces Web user settings ARN."
  }
}

variable "portal_arn" {
  description = "ARN of the portal to associate with the user settings. Forces replacement if changed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:", var.portal_arn))
    error_message = "resource_aws_workspacesweb_user_settings_association, portal_arn must be a valid WorkSpaces Web portal ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_workspacesweb_user_settings_association, region must be a valid AWS region identifier or null."
  }
}