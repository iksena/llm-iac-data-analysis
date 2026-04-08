variable "ip_access_settings_arn" {
  description = "ARN of the IP access settings to associate with the portal. Forces replacement if changed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:", var.ip_access_settings_arn))
    error_message = "resource_aws_workspacesweb_ip_access_settings_association, ip_access_settings_arn must be a valid ARN starting with 'arn:aws:workspaces-web:'."
  }
}

variable "portal_arn" {
  description = "ARN of the portal to associate with the IP access settings. Forces replacement if changed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:", var.portal_arn))
    error_message = "resource_aws_workspacesweb_ip_access_settings_association, portal_arn must be a valid ARN starting with 'arn:aws:workspaces-web:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_workspacesweb_ip_access_settings_association, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}