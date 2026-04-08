variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) A name for the QuickSight account settings."
  type        = string
  nullable    = false
}

variable "edition" {
  description = "(Required) The edition of QuickSight to use. Valid values are `STANDARD` and `ENTERPRISE`."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["STANDARD", "ENTERPRISE"], var.edition)
    error_message = "The value for `edition` must be either `STANDARD` or `ENTERPRISE`."
  }
}

variable "notification_email" {
  description = "(Required) The email address to send notifications for the QuickSight account and subscription."
  type        = string
  nullable    = false
}

variable "default_namespace" {
  description = "(Optional) The default namespace for the QuickSight account. Defaults to `default`."
  type        = string
  default     = "default"
  nullable    = false

  validation {
    condition     = length(var.default_namespace) <= 64
    error_message = "The `default_namespace` must not exceed 64 characters."
  }
}

variable "termination_protection_enabled" {
  description = "(Optional) Whether termination protection is enabled for the QuickSight account. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "authentication_method" {
  description = "(Optional) The authentication method for the QuickSight account. Valid values are `IAM_AND_QUICKSIGHT`, `IAM_ONLY`, `ACTIVE_DIRECTORY`, and `IAM_IDENTITY_CENTER`."
  type        = string
  default     = "IAM_AND_QUICKSIGHT"
  nullable    = false

  validation {
    condition     = contains(["IAM_AND_QUICKSIGHT", "IAM_ONLY", "ACTIVE_DIRECTORY", "IAM_IDENTITY_CENTER"], var.authentication_method)
    error_message = "The value for `authentication_method` must be one of `IAM_AND_QUICKSIGHT`, `IAM_ONLY`, `ACTIVE_DIRECTORY`, or `IAM_IDENTITY_CENTER`."
  }
}

variable "active_directory" {
  description = <<EOF
  (Optional) A configuration for Active Directory authentication. Only required for `ACTIVE_DIRECTORY` authentication method. `active_directory` as defined below.
    (Required) `name` - The name of the Active Directory to associate with the QuickSight account.
    (Required) `realm` - The realm for the Active Directory to associate with the QuickSight account.
    (Required) `directory_id` - The Active Directory ID to associate with the QuickSight account.
  EOF
  type = object({
    name         = string
    realm        = string
    directory_id = string
  })
  default  = null
  nullable = true

  validation {
    condition = anytrue([
      var.authentication_method != "ACTIVE_DIRECTORY",
      var.authentication_method == "ACTIVE_DIRECTORY" && var.active_directory != null,
    ])
    error_message = "The `active_directory` configuration must be specified for `ACTIVE_DIRECTORY` authentication method."
  }
}

variable "iam_identity_center" {
  description = <<EOF
  (Optional) A configuration for IAM Identity Center authentication. Only required for `IAM_IDENTITY_CENTER` authentication method. `iam_identity_center` as defined below.
    (Required) `instance` - The ARN of the IAM Identity Center instance.
  EOF
  type = object({
    instance = string
  })
  default  = null
  nullable = true

  validation {
    condition = anytrue([
      var.authentication_method != "IAM_IDENTITY_CENTER",
      var.authentication_method == "IAM_IDENTITY_CENTER" && var.iam_identity_center != null,
    ])
    error_message = "The `iam_identity_center` configuration must be specified for `IAM_IDENTITY_CENTER` authentication method."
  }
}

variable "role_memberships" {
  description = <<EOF
  (Optional) A configuration for initial role memberships in the QuickSight account. Only required for `ACTIVE_DIRECTORY` or `IAM_IDENTITY_CENTER` authentication methods. `role_memberships` as defined below.
    (Required) `admin` - A set of group names for the admin role. Required for both `ACTIVE_DIRECTORY` and `IAM_IDENTITY_CENTER` authentication methods for initial setup.
    (Optional) `admin_pro` - A set of group names for the admin pro role.
    (Optional) `author` - A set of group names for the author role.
    (Optional) `author_pro` - A set of group names for the author pro role.
    (Optional) `reader` - A set of group names for the reader role.
    (Optional) `reader_pro` - A set of group names for the reader pro role.
  EOF
  type = object({
    admin      = set(string)
    admin_pro  = optional(set(string), [])
    author     = optional(set(string), [])
    author_pro = optional(set(string), [])
    reader     = optional(set(string), [])
    reader_pro = optional(set(string), [])
  })
  default  = null
  nullable = true

  validation {
    condition = anytrue([
      !contains(["ACTIVE_DIRECTORY", "IAM_IDENTITY_CENTER"], var.authentication_method),
      contains(["ACTIVE_DIRECTORY", "IAM_IDENTITY_CENTER"], var.authentication_method) && var.role_memberships != null,
    ])
    error_message = "The `role_memberships` must be specified for `ACTIVE_DIRECTORY` or `IAM_IDENTITY_CENTER` authentication methods."
  }
}

variable "timeouts" {
  description = "(Optional) How long to wait for the QuickSight account subscription to be created/deleted."
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default  = {}
  nullable = false
}
