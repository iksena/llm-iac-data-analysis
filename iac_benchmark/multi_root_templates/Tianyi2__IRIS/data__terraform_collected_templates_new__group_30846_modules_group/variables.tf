variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) A name for the QuickSight group."
  type        = string
  nullable    = false
}

variable "type" {
  description = "(Optional) The type of the QuickSight group. Valid values are `INTERNAL` and `EXTERNAL`. Defaults to `INTERNAL`. `EXTERNAL` for the Active Directory or IAM Identity Center authentication method."
  type        = string
  default     = "INTERNAL"
  nullable    = false

  validation {
    condition     = contains(["INTERNAL", "EXTERNAL"], var.type)
    error_message = "The type must be either `INTERNAL` or `EXTERNAL`."
  }
}

variable "description" {
  description = "(Optional) A description for the QuickSight group. Only applicable for `INTERNAL` type groups."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "namespace" {
  description = "(Optional) The namespace that you want the group to be a part of."
  type        = string
  default     = "default"
  nullable    = false
}

variable "members" {
  description = "(Optional) A set of user names that you want to add to the group membership."
  type        = set(string)
  default     = []
  nullable    = false
}

variable "role" {
  description = "(Optional) The QuickSight role to assign to the group. Valid values are `NONE`, `ADMIN`, `ADMIN_PRO`, `AUTHOR`, `AUTHOR_PRO`, `READER`, and `READER_PRO`. Defaults to `NONE`."
  type        = string
  default     = "NONE"
  nullable    = false

  validation {
    condition     = contains(["NONE", "ADMIN", "ADMIN_PRO", "AUTHOR", "AUTHOR_PRO", "READER", "READER_PRO"], var.role)
    error_message = "The value for `role` must be one of `NONE`, `ADMIN`, `ADMIN_PRO`, `AUTHOR`, `AUTHOR_PRO`, `READER`, or `READER_PRO`."
  }
}
