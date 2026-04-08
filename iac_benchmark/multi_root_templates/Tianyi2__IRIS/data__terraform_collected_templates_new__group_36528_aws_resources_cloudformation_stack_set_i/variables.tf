variable "stack_set_name" {
  description = "Name of the StackSet"
  type        = string

  validation {
    condition     = length(var.stack_set_name) > 0
    error_message = "resource_aws_cloudformation_stack_set_instance, stack_set_name cannot be empty."
  }
}

variable "account_id" {
  description = "Target AWS Account ID to create a Stack based on the StackSet. Defaults to current account"
  type        = string
  default     = null

  validation {
    condition = var.account_id == null || (
      can(regex("^[0-9]{12}$", var.account_id))
    )
    error_message = "resource_aws_cloudformation_stack_set_instance, account_id must be a 12-digit AWS Account ID."
  }
}

variable "call_as" {
  description = "Specifies whether you are acting as an account administrator in the organization's management account or as a delegated administrator in a member account"
  type        = string
  default     = "SELF"

  validation {
    condition     = contains(["SELF", "DELEGATED_ADMIN"], var.call_as)
    error_message = "resource_aws_cloudformation_stack_set_instance, call_as must be either 'SELF' or 'DELEGATED_ADMIN'."
  }
}

variable "deployment_targets" {
  description = "AWS Organizations accounts to which StackSets deploys"
  type = object({
    organizational_unit_ids = optional(set(string))
    account_filter_type     = optional(string)
    accounts                = optional(set(string))
    accounts_url            = optional(string)
  })
  default = null

  validation {
    condition = var.deployment_targets == null || (
      var.deployment_targets.account_filter_type == null ||
      contains(["INTERSECTION", "DIFFERENCE", "UNION", "NONE"], var.deployment_targets.account_filter_type)
    )
    error_message = "resource_aws_cloudformation_stack_set_instance, deployment_targets.account_filter_type must be one of: INTERSECTION, DIFFERENCE, UNION, NONE."
  }

  validation {
    condition = var.deployment_targets == null || (
      var.deployment_targets.accounts == null ||
      alltrue([for account in var.deployment_targets.accounts : can(regex("^[0-9]{12}$", account))])
    )
    error_message = "resource_aws_cloudformation_stack_set_instance, deployment_targets.accounts must contain valid 12-digit AWS Account IDs."
  }

  validation {
    condition = var.deployment_targets == null || (
      var.deployment_targets.accounts_url == null ||
      can(regex("^s3://", var.deployment_targets.accounts_url))
    )
    error_message = "resource_aws_cloudformation_stack_set_instance, deployment_targets.accounts_url must be a valid S3 URL starting with 's3://'."
  }
}

variable "operation_preferences" {
  description = "Preferences for how AWS CloudFormation performs a stack set operation"
  type = object({
    failure_tolerance_count      = optional(number)
    failure_tolerance_percentage = optional(number)
    max_concurrent_count         = optional(number)
    max_concurrent_percentage    = optional(number)
    concurrency_mode             = optional(string)
    region_concurrency_type      = optional(string)
    region_order                 = optional(list(string))
  })
  default = null

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences.failure_tolerance_count == null ||
      var.operation_preferences.failure_tolerance_count >= 0
    )
    error_message = "resource_aws_cloudformation_stack_set_instance, operation_preferences.failure_tolerance_count must be >= 0."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences.failure_tolerance_percentage == null ||
      (var.operation_preferences.failure_tolerance_percentage >= 0 && var.operation_preferences.failure_tolerance_percentage <= 100)
    )
    error_message = "resource_aws_cloudformation_stack_set_instance, operation_preferences.failure_tolerance_percentage must be between 0 and 100."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences.max_concurrent_count == null ||
      var.operation_preferences.max_concurrent_count >= 1
    )
    error_message = "resource_aws_cloudformation_stack_set_instance, operation_preferences.max_concurrent_count must be >= 1."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences.max_concurrent_percentage == null ||
      (var.operation_preferences.max_concurrent_percentage >= 1 && var.operation_preferences.max_concurrent_percentage <= 100)
    )
    error_message = "resource_aws_cloudformation_stack_set_instance, operation_preferences.max_concurrent_percentage must be between 1 and 100."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences.concurrency_mode == null ||
      contains(["STRICT_FAILURE_TOLERANCE", "SOFT_FAILURE_TOLERANCE"], var.operation_preferences.concurrency_mode)
    )
    error_message = "resource_aws_cloudformation_stack_set_instance, operation_preferences.concurrency_mode must be either 'STRICT_FAILURE_TOLERANCE' or 'SOFT_FAILURE_TOLERANCE'."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences.region_concurrency_type == null ||
      contains(["SEQUENTIAL", "PARALLEL"], var.operation_preferences.region_concurrency_type)
    )
    error_message = "resource_aws_cloudformation_stack_set_instance, operation_preferences.region_concurrency_type must be either 'SEQUENTIAL' or 'PARALLEL'."
  }
}

variable "parameter_overrides" {
  description = "Key-value map of input parameters to override from the StackSet for this Instance"
  type        = map(string)
  default     = null
}

variable "retain_stack" {
  description = "During Terraform resource destroy, remove Instance from StackSet while keeping the Stack and its associated resources"
  type        = bool
  default     = false
}

variable "stack_set_instance_region" {
  description = "Target AWS Region to create a Stack based on the StackSet. Defaults to current region"
  type        = string
  default     = null

  validation {
    condition = var.stack_set_instance_region == null || (
      can(regex("^[a-z0-9-]+$", var.stack_set_instance_region))
    )
    error_message = "resource_aws_cloudformation_stack_set_instance, stack_set_instance_region must be a valid AWS region format."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the CloudFormation Stack Set Instance"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.create_timeout))
    error_message = "resource_aws_cloudformation_stack_set_instance, create_timeout must be a valid duration (e.g., '30m', '1h', '90s')."
  }
}

variable "update_timeout" {
  description = "Timeout for updating the CloudFormation Stack Set Instance"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.update_timeout))
    error_message = "resource_aws_cloudformation_stack_set_instance, update_timeout must be a valid duration (e.g., '30m', '1h', '90s')."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the CloudFormation Stack Set Instance"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.delete_timeout))
    error_message = "resource_aws_cloudformation_stack_set_instance, delete_timeout must be a valid duration (e.g., '30m', '1h', '90s')."
  }
}