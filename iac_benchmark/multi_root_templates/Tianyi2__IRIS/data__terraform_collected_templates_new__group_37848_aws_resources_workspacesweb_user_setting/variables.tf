variable "copy_allowed" {
  description = "Specifies whether the user can copy text from the streaming session to the local device"
  type        = string
  validation {
    condition     = contains(["Enabled", "Disabled"], var.copy_allowed)
    error_message = "resource_aws_workspacesweb_user_settings, copy_allowed must be either 'Enabled' or 'Disabled'."
  }
}

variable "download_allowed" {
  description = "Specifies whether the user can download files from the streaming session to the local device"
  type        = string
  validation {
    condition     = contains(["Enabled", "Disabled"], var.download_allowed)
    error_message = "resource_aws_workspacesweb_user_settings, download_allowed must be either 'Enabled' or 'Disabled'."
  }
}

variable "paste_allowed" {
  description = "Specifies whether the user can paste text from the local device to the streaming session"
  type        = string
  validation {
    condition     = contains(["Enabled", "Disabled"], var.paste_allowed)
    error_message = "resource_aws_workspacesweb_user_settings, paste_allowed must be either 'Enabled' or 'Disabled'."
  }
}

variable "print_allowed" {
  description = "Specifies whether the user can print to the local device"
  type        = string
  validation {
    condition     = contains(["Enabled", "Disabled"], var.print_allowed)
    error_message = "resource_aws_workspacesweb_user_settings, print_allowed must be either 'Enabled' or 'Disabled'."
  }
}

variable "upload_allowed" {
  description = "Specifies whether the user can upload files from the local device to the streaming session"
  type        = string
  validation {
    condition     = contains(["Enabled", "Disabled"], var.upload_allowed)
    error_message = "resource_aws_workspacesweb_user_settings, upload_allowed must be either 'Enabled' or 'Disabled'."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "additional_encryption_context" {
  description = "Additional encryption context for the user settings"
  type        = map(string)
  default     = null
}

variable "associated_portal_arns" {
  description = "List of web portal ARNs to associate with the user settings"
  type        = list(string)
  default     = null
}

variable "customer_managed_key" {
  description = "ARN of the customer managed KMS key"
  type        = string
  default     = null
}

variable "deep_link_allowed" {
  description = "Specifies whether the user can use deep links that open automatically when connecting to a session"
  type        = string
  default     = null
  validation {
    condition     = var.deep_link_allowed == null || contains(["Enabled", "Disabled"], var.deep_link_allowed)
    error_message = "resource_aws_workspacesweb_user_settings, deep_link_allowed must be either 'Enabled' or 'Disabled'."
  }
}

variable "disconnect_timeout_in_minutes" {
  description = "Amount of time that a streaming session remains active after users disconnect"
  type        = number
  default     = null
  validation {
    condition     = var.disconnect_timeout_in_minutes == null || (var.disconnect_timeout_in_minutes >= 1 && var.disconnect_timeout_in_minutes <= 600)
    error_message = "resource_aws_workspacesweb_user_settings, disconnect_timeout_in_minutes must be between 1 and 600 minutes."
  }
}

variable "idle_disconnect_timeout_in_minutes" {
  description = "Amount of time that users can be idle before they are disconnected from their streaming session"
  type        = number
  default     = null
  validation {
    condition     = var.idle_disconnect_timeout_in_minutes == null || (var.idle_disconnect_timeout_in_minutes >= 0 && var.idle_disconnect_timeout_in_minutes <= 60)
    error_message = "resource_aws_workspacesweb_user_settings, idle_disconnect_timeout_in_minutes must be between 0 and 60 minutes."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource"
  type        = map(string)
  default     = null
}

variable "cookie_synchronization_configuration" {
  description = "Configuration that specifies which cookies should be synchronized from the end user's local browser to the remote browser"
  type = object({
    allowlist = list(object({
      domain = string
      name   = optional(string)
      path   = optional(string)
    }))
    blocklist = optional(list(object({
      domain = string
      name   = optional(string)
      path   = optional(string)
    })))
  })
  default = null
}

variable "toolbar_configuration" {
  description = "Configuration of the toolbar"
  type = object({
    hidden_toolbar_items   = optional(list(string))
    max_display_resolution = optional(string)
    toolbar_type           = optional(string)
    visual_mode            = optional(string)
  })
  default = null
}