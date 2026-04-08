variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account_id" {
  description = "The AWS account ID for the account that owns the Object Lambda Access Point. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.account_id == null || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_s3control_object_lambda_access_point_policy, account_id must be a valid 12-digit AWS account ID."
  }
}

variable "name" {
  description = "The name of the Object Lambda Access Point."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 45
    error_message = "resource_aws_s3control_object_lambda_access_point_policy, name must be between 1 and 45 characters long."
  }

  validation {
    condition     = can(regex("^[a-z0-9\\-]+$", var.name))
    error_message = "resource_aws_s3control_object_lambda_access_point_policy, name must contain only lowercase alphanumeric characters and hyphens."
  }
}

variable "policy" {
  description = "The Object Lambda Access Point resource policy document."
  type        = string

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_s3control_object_lambda_access_point_policy, policy must not be empty."
  }

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_s3control_object_lambda_access_point_policy, policy must be valid JSON."
  }
}