variable "aws_service_name" {
  description = "The AWS service to which this role is attached. You use a string similar to a URL but without the http:// in front."
  type        = string

  validation {
    condition     = length(var.aws_service_name) > 0
    error_message = "resource_aws_iam_service_linked_role, aws_service_name must not be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+$", var.aws_service_name))
    error_message = "resource_aws_iam_service_linked_role, aws_service_name must contain only alphanumeric characters, dots, and hyphens."
  }
}

variable "custom_suffix" {
  description = "Additional string appended to the role name. Not all AWS services support custom suffixes."
  type        = string
  default     = null

  validation {
    condition     = var.custom_suffix == null || length(var.custom_suffix) > 0
    error_message = "resource_aws_iam_service_linked_role, custom_suffix must not be empty if specified."
  }
}

variable "description" {
  description = "The description of the role."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) > 0
    error_message = "resource_aws_iam_service_linked_role, description must not be empty if specified."
  }
}

variable "tags" {
  description = "Key-value mapping of tags for the IAM role."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) > 0 && length(v) >= 0])
    error_message = "resource_aws_iam_service_linked_role, tags keys must not be empty."
  }
}