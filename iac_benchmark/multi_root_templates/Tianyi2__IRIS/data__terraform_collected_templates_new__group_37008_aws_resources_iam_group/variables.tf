variable "name" {
  description = "The group's name. The name must consist of upper and lowercase alphanumeric characters with no spaces. You can also include any of the following characters: =,.@-_."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9=,.@\\-_.]+$", var.name))
    error_message = "resource_aws_iam_group, name must consist of upper and lowercase alphanumeric characters with no spaces. You can also include any of the following characters: =,.@-_."
  }

  validation {
    condition     = length(var.name) <= 128
    error_message = "resource_aws_iam_group, name must be 128 characters or less."
  }

  validation {
    condition     = length(var.name) >= 1
    error_message = "resource_aws_iam_group, name must be at least 1 character."
  }
}

variable "path" {
  description = "Path in which to create the group"
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$", var.path))
    error_message = "resource_aws_iam_group, path must start and end with a forward slash (/)."
  }

  validation {
    condition     = length(var.path) <= 512
    error_message = "resource_aws_iam_group, path must be 512 characters or less."
  }
}