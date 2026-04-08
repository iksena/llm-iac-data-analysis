variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "bundle_id" {
  type        = string
  description = "ID of the bundle for the WorkSpace."
  default     = null
}

variable "directory_id" {
  type        = string
  description = "ID of the directory for the WorkSpace. You have to specify user_name along with directory_id. You cannot combine this parameter with workspace_id."
  default     = null

}

variable "root_volume_encryption_enabled" {
  type        = bool
  description = "Indicates whether the data stored on the root volume is encrypted."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags for the WorkSpace."
  default     = null
}

variable "user_name" {
  type        = string
  description = "User name of the user for the WorkSpace. This user name must exist in the directory for the WorkSpace. You cannot combine this parameter with workspace_id."
  default     = null

}

variable "user_volume_encryption_enabled" {
  type        = bool
  description = "Indicates whether the data stored on the user volume is encrypted."
  default     = null
}

variable "volume_encryption_key" {
  type        = string
  description = "Symmetric AWS KMS customer master key (CMK) used to encrypt data stored on your WorkSpace. Amazon WorkSpaces does not support asymmetric CMKs."
  default     = null
}

variable "workspace_id" {
  type        = string
  description = "ID of the WorkSpace. You cannot combine this parameter with directory_id."
  default     = null

}

variable "workspace_properties" {
  type = object({
    compute_type_name                         = optional(string)
    root_volume_size_gib                      = optional(number)
    running_mode                              = optional(string)
    running_mode_auto_stop_timeout_in_minutes = optional(number)
    user_volume_size_gib                      = optional(number)
  })
  description = "WorkSpace properties."
  default     = null

  validation {
    condition = var.workspace_properties == null || (
      var.workspace_properties.compute_type_name == null ||
      contains(["VALUE", "STANDARD", "PERFORMANCE", "POWER", "GRAPHICS", "POWERPRO", "GRAPHICSPRO"], var.workspace_properties.compute_type_name)
    )
    error_message = "data_aws_workspaces_workspace, compute_type_name: Valid values are VALUE, STANDARD, PERFORMANCE, POWER, GRAPHICS, POWERPRO and GRAPHICSPRO."
  }

  validation {
    condition = var.workspace_properties == null || (
      var.workspace_properties.running_mode == null ||
      contains(["AUTO_STOP", "ALWAYS_ON"], var.workspace_properties.running_mode)
    )
    error_message = "data_aws_workspaces_workspace, running_mode: Valid values are AUTO_STOP and ALWAYS_ON."
  }
}