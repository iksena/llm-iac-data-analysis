variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) A name for the QuickSight user."
  type        = string
  nullable    = false
}

variable "type" {
  description = "(Optional) The type of the QuickSight user. Valid values are `INTERNAL` and `EXTERNAL`. Defaults to `INTERNAL`. `EXTERNAL` for the Active Directory or IAM Identity Center authentication method."
  type        = string
  default     = "INTERNAL"
  nullable    = false

  validation {
    condition     = contains(["INTERNAL", "EXTERNAL"], var.type)
    error_message = "The type must be either `INTERNAL` or `EXTERNAL`."
  }
}

variable "namespace" {
  description = "(Optional) The namespace that you want the user to be a part of."
  type        = string
  default     = "default"
  nullable    = false
}

variable "email" {
  description = "(Optional) The email address of the user that you want to register. Only required for `INTERNAL` type users."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition = anytrue([
      var.type == "EXTERNAL",
      var.type == "INTERNAL" && var.email != null,
    ])
    error_message = "The email address is required for `INTERNAL` type users. For `EXTERNAL` type users, it can be omitted."
  }
}

variable "role" {
  description = "(Optional) The Amazon QuickSight role for the user. Valid values are `ADMIN`, `ADMIN_PRO`, `AUTHOR`, `AUTHOR_PRO`, `READER` and `READER_PRO`. Only required for `INTERNAL` type users. Defaults to `READER`."
  type        = string
  default     = "READER"
  nullable    = false

  validation {
    condition     = contains(["ADMIN", "ADMIN_PRO", "AUTHOR", "AUTHOR_PRO", "READER", "READER_PRO"], var.role)
    error_message = "The role must be one of `ADMIN`, `ADMIN_PRO`, `AUTHOR`, `AUTHOR_PRO`, `READER`, or `READER_PRO`."
  }
}
