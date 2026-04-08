variable "user_access_logging_settings_arn" {
  description = "ARN of the user access logging settings to associate with the portal. Forces replacement if changed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:", var.user_access_logging_settings_arn))
    error_message = "resource_aws_workspacesweb_user_access_logging_settings_association, user_access_logging_settings_arn must be a valid WorkSpaces Web user access logging settings ARN starting with 'arn:aws:workspaces-web:'."
  }
}

variable "portal_arn" {
  description = "ARN of the portal to associate with the user access logging settings. Forces replacement if changed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:", var.portal_arn))
    error_message = "resource_aws_workspacesweb_user_access_logging_settings_association, portal_arn must be a valid WorkSpaces Web portal ARN starting with 'arn:aws:workspaces-web:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_workspacesweb_user_access_logging_settings_association, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}