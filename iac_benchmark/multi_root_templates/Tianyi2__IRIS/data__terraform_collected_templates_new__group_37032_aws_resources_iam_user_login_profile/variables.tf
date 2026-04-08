variable "user" {
  description = "The IAM user's name"
  type        = string

  validation {
    condition     = length(var.user) > 0
    error_message = "resource_aws_iam_user_login_profile, user must be a non-empty string."
  }
}

variable "pgp_key" {
  description = "Either a base-64 encoded PGP public key, or a keybase username in the form 'keybase:username'. Only applies on resource creation. Drift detection is not possible with this argument."
  type        = string
  default     = null
}

variable "password_length" {
  description = "The length of the generated password on resource creation. Only applies on resource creation. Drift detection is not possible with this argument. Default value is 20."
  type        = number
  default     = 20

  validation {
    condition     = var.password_length >= 4 && var.password_length <= 128
    error_message = "resource_aws_iam_user_login_profile, password_length must be between 4 and 128 characters."
  }
}

variable "password_reset_required" {
  description = "Whether the user should be forced to reset the generated password on resource creation. Only applies on resource creation."
  type        = bool
  default     = null
}