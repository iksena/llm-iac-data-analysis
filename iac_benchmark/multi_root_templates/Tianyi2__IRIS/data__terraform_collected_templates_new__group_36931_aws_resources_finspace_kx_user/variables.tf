variable "name" {
  description = "A unique identifier for the user."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_finspace_kx_user, name must not be empty."
  }
}

variable "environment_id" {
  description = "Unique identifier for the KX environment."
  type        = string

  validation {
    condition     = length(var.environment_id) > 0
    error_message = "resource_aws_finspace_kx_user, environment_id must not be empty."
  }
}

variable "iam_role" {
  description = "IAM role ARN to be associated with the user."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.iam_role))
    error_message = "resource_aws_finspace_kx_user, iam_role must be a valid IAM role ARN starting with 'arn:aws:iam::'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for creating the FinSpace KX user."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_finspace_kx_user, create_timeout must be a valid timeout format (e.g., 30m, 1h, 300s)."
  }
}

variable "update_timeout" {
  description = "Timeout for updating the FinSpace KX user."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.update_timeout))
    error_message = "resource_aws_finspace_kx_user, update_timeout must be a valid timeout format (e.g., 30m, 1h, 300s)."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the FinSpace KX user."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_finspace_kx_user, delete_timeout must be a valid timeout format (e.g., 30m, 1h, 300s)."
  }
}