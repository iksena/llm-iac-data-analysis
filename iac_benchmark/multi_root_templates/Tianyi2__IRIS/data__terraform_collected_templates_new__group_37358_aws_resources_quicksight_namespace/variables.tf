variable "namespace" {
  description = "Name of the namespace."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.namespace))
    error_message = "resource_aws_quicksight_namespace, namespace must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_namespace, aws_account_id must be a 12-digit number."
  }
}

variable "identity_store" {
  description = "User identity directory type. Defaults to QUICKSIGHT, the only current valid value."
  type        = string
  default     = "QUICKSIGHT"

  validation {
    condition     = var.identity_store == "QUICKSIGHT"
    error_message = "resource_aws_quicksight_namespace, identity_store must be 'QUICKSIGHT'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Timeout for creating the namespace."
  type        = string
  default     = "2m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_quicksight_namespace, timeouts_create must be a valid duration (e.g., '2m', '30s', '1h')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the namespace."
  type        = string
  default     = "2m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_quicksight_namespace, timeouts_delete must be a valid duration (e.g., '2m', '30s', '1h')."
  }
}