variable "virtual_mfa_device_name" {
  description = "The name of the virtual MFA device. Use with path to uniquely identify a virtual MFA device."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_+=,.@-]+$", var.virtual_mfa_device_name))
    error_message = "resource_aws_iam_virtual_mfa_device, virtual_mfa_device_name must contain only alphanumeric characters, hyphens, underscores, commas, periods, @ symbols, plus signs, and equals signs."
  }

  validation {
    condition     = length(var.virtual_mfa_device_name) >= 1 && length(var.virtual_mfa_device_name) <= 226
    error_message = "resource_aws_iam_virtual_mfa_device, virtual_mfa_device_name must be between 1 and 226 characters long."
  }
}

variable "path" {
  description = "The path for the virtual MFA device."
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/[a-zA-Z0-9_+=,.@-]*/$", var.path))
    error_message = "resource_aws_iam_virtual_mfa_device, path must begin and end with a forward slash and contain only alphanumeric characters, hyphens, underscores, commas, periods, @ symbols, plus signs, and equals signs."
  }

  validation {
    condition     = length(var.path) >= 1 && length(var.path) <= 512
    error_message = "resource_aws_iam_virtual_mfa_device, path must be between 1 and 512 characters long."
  }
}

variable "tags" {
  description = "Map of resource tags for the virtual mfa device."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) <= 128])
    error_message = "resource_aws_iam_virtual_mfa_device, tags keys must be 128 characters or less."
  }

  validation {
    condition     = alltrue([for k, v in var.tags : length(v) <= 256])
    error_message = "resource_aws_iam_virtual_mfa_device, tags values must be 256 characters or less."
  }

  validation {
    condition     = length(var.tags) <= 50
    error_message = "resource_aws_iam_virtual_mfa_device, tags cannot exceed 50 key-value pairs."
  }
}