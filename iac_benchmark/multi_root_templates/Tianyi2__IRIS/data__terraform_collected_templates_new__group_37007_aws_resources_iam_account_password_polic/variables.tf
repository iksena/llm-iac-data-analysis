variable "allow_users_to_change_password" {
  description = "Whether to allow users to change their own password"
  type        = bool
  default     = null
}

variable "hard_expiry" {
  description = "Whether users are prevented from setting a new password after their password has expired (i.e., require administrator reset)"
  type        = bool
  default     = null
}

variable "max_password_age" {
  description = "The number of days that an user password is valid"
  type        = number
  default     = null

  validation {
    condition     = var.max_password_age == null || (var.max_password_age >= 0 && var.max_password_age <= 1095)
    error_message = "resource_aws_iam_account_password_policy, max_password_age must be between 0 and 1095 days."
  }
}

variable "minimum_password_length" {
  description = "Minimum length to require for user passwords"
  type        = number
  default     = null

  validation {
    condition     = var.minimum_password_length == null || (var.minimum_password_length >= 6 && var.minimum_password_length <= 128)
    error_message = "resource_aws_iam_account_password_policy, minimum_password_length must be between 6 and 128 characters."
  }
}

variable "password_reuse_prevention" {
  description = "The number of previous passwords that users are prevented from reusing"
  type        = number
  default     = null

  validation {
    condition     = var.password_reuse_prevention == null || (var.password_reuse_prevention >= 1 && var.password_reuse_prevention <= 24)
    error_message = "resource_aws_iam_account_password_policy, password_reuse_prevention must be between 1 and 24."
  }
}

variable "require_lowercase_characters" {
  description = "Whether to require lowercase characters for user passwords"
  type        = bool
  default     = null
}

variable "require_numbers" {
  description = "Whether to require numbers for user passwords"
  type        = bool
  default     = null
}

variable "require_symbols" {
  description = "Whether to require symbols for user passwords"
  type        = bool
  default     = null
}

variable "require_uppercase_characters" {
  description = "Whether to require uppercase characters for user passwords"
  type        = bool
  default     = null
}