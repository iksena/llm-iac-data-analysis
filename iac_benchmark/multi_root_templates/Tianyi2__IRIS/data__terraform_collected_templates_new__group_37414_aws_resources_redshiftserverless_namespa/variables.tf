variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "admin_password_secret_kms_key_id" {
  description = "ID of the KMS key used to encrypt the namespace's admin credentials secret."
  type        = string
  default     = null
}

variable "admin_user_password" {
  description = "The password of the administrator for the first database created in the namespace. Conflicts with manage_admin_password and admin_user_password_wo."
  type        = string
  default     = null
  sensitive   = true
}

variable "admin_user_password_wo" {
  description = "The password of the administrator for the first database created in the namespace (Write-Only). Conflicts with manage_admin_password and admin_user_password."
  type        = string
  default     = null
  sensitive   = true
}

variable "admin_user_password_wo_version" {
  description = "Used together with admin_user_password_wo to trigger an update. Increment this value when an update to the admin_user_password_wo is required."
  type        = number
  default     = null
}

variable "admin_username" {
  description = "The username of the administrator for the first database created in the namespace."
  type        = string
  default     = null
}

variable "db_name" {
  description = "The name of the first database created in the namespace."
  type        = string
  default     = null
}

variable "default_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role to set as a default in the namespace. When specifying default_iam_role_arn, it also must be part of iam_roles."
  type        = string
  default     = null

  validation {
    condition     = var.default_iam_role_arn == null || (var.iam_roles != null && contains(var.iam_roles, var.default_iam_role_arn))
    error_message = "resource_aws_redshiftserverless_namespace, default_iam_role_arn must be part of iam_roles when specified."
  }
}

variable "iam_roles" {
  description = "A list of IAM roles to associate with the namespace."
  type        = list(string)
  default     = null
}

variable "kms_key_id" {
  description = "The ARN of the Amazon Web Services Key Management Service key used to encrypt your data."
  type        = string
  default     = null
}

variable "log_exports" {
  description = "The types of logs the namespace can export. Available export types are userlog, connectionlog, and useractivitylog."
  type        = list(string)
  default     = null

  validation {
    condition = var.log_exports == null || alltrue([
      for log_type in var.log_exports : contains(["userlog", "connectionlog", "useractivitylog"], log_type)
    ])
    error_message = "resource_aws_redshiftserverless_namespace, log_exports must contain only valid export types: userlog, connectionlog, useractivitylog."
  }
}

variable "namespace_name" {
  description = "The name of the namespace."
  type        = string

  validation {
    condition     = var.namespace_name != null && var.namespace_name != ""
    error_message = "resource_aws_redshiftserverless_namespace, namespace_name is required and cannot be empty."
  }
}

variable "manage_admin_password" {
  description = "Whether to use AWS SecretManager to manage namespace's admin credentials. Conflicts with admin_user_password and admin_user_password_wo."
  type        = bool
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}