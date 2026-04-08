variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account_id" {
  description = "The AWS account ID for the owner of the Multi-Region Access Point. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.account_id == null || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_s3control_multi_region_access_point_policy, account_id must be a 12-digit AWS account ID."
  }
}

variable "details_name" {
  description = "The name of the Multi-Region Access Point."
  type        = string

  validation {
    condition     = length(var.details_name) > 0
    error_message = "resource_aws_s3control_multi_region_access_point_policy, details_name cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.details_name))
    error_message = "resource_aws_s3control_multi_region_access_point_policy, details_name must contain only lowercase letters, numbers, and hyphens, and must start and end with a letter or number."
  }

  validation {
    condition     = length(var.details_name) <= 50
    error_message = "resource_aws_s3control_multi_region_access_point_policy, details_name must be 50 characters or less."
  }
}

variable "details_policy" {
  description = "A valid JSON document that specifies the policy that you want to associate with this Multi-Region Access Point. Once applied, the policy can be edited, but not deleted."
  type        = string

  validation {
    condition     = length(var.details_policy) > 0
    error_message = "resource_aws_s3control_multi_region_access_point_policy, details_policy cannot be empty."
  }

  validation {
    condition     = can(jsondecode(var.details_policy))
    error_message = "resource_aws_s3control_multi_region_access_point_policy, details_policy must be a valid JSON document."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operation."
  type        = string
  default     = "15m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_s3control_multi_region_access_point_policy, timeouts_create must be a valid timeout format (e.g., '15m', '1h', '30s')."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operation."
  type        = string
  default     = "15m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_s3control_multi_region_access_point_policy, timeouts_update must be a valid timeout format (e.g., '15m', '1h', '30s')."
  }
}