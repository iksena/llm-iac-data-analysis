variable "network_settings_arn" {
  description = "ARN of the network settings to associate with the portal. Forces replacement if changed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:[a-z0-9-]+:[0-9]{12}:networkSettings/[a-zA-Z0-9-]+$", var.network_settings_arn))
    error_message = "resource_aws_workspacesweb_network_settings_association, network_settings_arn must be a valid ARN for WorkSpaces Web network settings."
  }
}

variable "portal_arn" {
  description = "ARN of the portal to associate with the network settings. Forces replacement if changed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:[a-z0-9-]+:[0-9]{12}:portal/[a-zA-Z0-9-]+$", var.portal_arn))
    error_message = "resource_aws_workspacesweb_network_settings_association, portal_arn must be a valid ARN for WorkSpaces Web portal."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_workspacesweb_network_settings_association, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}