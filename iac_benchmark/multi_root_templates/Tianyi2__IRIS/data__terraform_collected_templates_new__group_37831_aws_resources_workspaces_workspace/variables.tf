variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "directory_id" {
  description = "The ID of the directory for the WorkSpace."
  type        = string
}

variable "bundle_id" {
  description = "The ID of the bundle for the WorkSpace."
  type        = string
}

variable "user_name" {
  description = "The user name of the user for the WorkSpace. This user name must exist in the directory for the WorkSpace."
  type        = string
}

variable "root_volume_encryption_enabled" {
  description = "Indicates whether the data stored on the root volume is encrypted."
  type        = bool
  default     = null
}

variable "user_volume_encryption_enabled" {
  description = "Indicates whether the data stored on the user volume is encrypted."
  type        = bool
  default     = null
}

variable "volume_encryption_key" {
  description = "The ARN of a symmetric AWS KMS customer master key (CMK) used to encrypt data stored on your WorkSpace. Amazon WorkSpaces does not support asymmetric CMKs."
  type        = string
  default     = null
}

variable "tags" {
  description = "The tags for the WorkSpace."
  type        = map(string)
  default     = {}
}

variable "workspace_properties" {
  description = "The WorkSpace properties."
  type = object({
    compute_type_name                         = optional(string)
    root_volume_size_gib                      = optional(number)
    running_mode                              = optional(string)
    running_mode_auto_stop_timeout_in_minutes = optional(number)
    user_volume_size_gib                      = optional(number)
  })
  default = null

  validation {
    condition = var.workspace_properties == null || var.workspace_properties.compute_type_name == null || contains([
      "VALUE", "STANDARD", "PERFORMANCE", "POWER", "GRAPHICS", "POWERPRO", "GRAPHICSPRO", "GRAPHICS_G4DN", "GRAPHICSPRO_G4DN"
    ], var.workspace_properties.compute_type_name)
    error_message = "resource_aws_workspaces_workspace, compute_type_name must be one of: VALUE, STANDARD, PERFORMANCE, POWER, GRAPHICS, POWERPRO, GRAPHICSPRO, GRAPHICS_G4DN, GRAPHICSPRO_G4DN."
  }

  validation {
    condition = var.workspace_properties == null || var.workspace_properties.running_mode == null || contains([
      "AUTO_STOP", "ALWAYS_ON"
    ], var.workspace_properties.running_mode)
    error_message = "resource_aws_workspaces_workspace, running_mode must be one of: AUTO_STOP, ALWAYS_ON."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the workspace."
  type        = string
  default     = "30m"
}

variable "update_timeout" {
  description = "Timeout for updating the workspace."
  type        = string
  default     = "10m"
}

variable "delete_timeout" {
  description = "Timeout for deleting the workspace."
  type        = string
  default     = "10m"
}