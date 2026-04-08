variable "name" {
  description = "The user's name. The name must consist of upper and lowercase alphanumeric characters with no spaces. You can also include any of the following characters: =,.@-_."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9=,.@_-]+$", var.name))
    error_message = "resource_aws_iam_user, name must consist of upper and lowercase alphanumeric characters with no spaces. You can also include any of the following characters: =,.@-_."
  }

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "resource_aws_iam_user, name must be between 1 and 64 characters in length."
  }
}

variable "path" {
  description = "Path in which to create the user"
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$", var.path))
    error_message = "resource_aws_iam_user, path must start and end with a forward slash (/)."
  }

  validation {
    condition     = length(var.path) >= 1 && length(var.path) <= 512
    error_message = "resource_aws_iam_user, path must be between 1 and 512 characters in length."
  }
}

variable "permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the user"
  type        = string
  default     = null

  validation {
    condition     = var.permissions_boundary == null || can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:policy/.+$", var.permissions_boundary))
    error_message = "resource_aws_iam_user, permissions_boundary must be a valid IAM policy ARN."
  }
}

variable "force_destroy" {
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Key-value map of tags for the IAM user"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) >= 1 && length(k) <= 128])
    error_message = "resource_aws_iam_user, tags keys must be between 1 and 128 characters in length."
  }

  validation {
    condition     = alltrue([for k, v in var.tags : length(v) >= 0 && length(v) <= 256])
    error_message = "resource_aws_iam_user, tags values must be between 0 and 256 characters in length."
  }
}