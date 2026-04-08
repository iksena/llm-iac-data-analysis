variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "administration_role_arn" {
  description = "Amazon Resource Number (ARN) of the IAM Role in the administrator account. This must be defined when using the SELF_MANAGED permission model."
  type        = string
  default     = null

  validation {
    condition     = var.administration_role_arn == null || can(regex("^arn:aws:iam::", var.administration_role_arn))
    error_message = "resource_aws_cloudformation_stack_set, administration_role_arn must be a valid IAM role ARN starting with 'arn:aws:iam::'."
  }
}

variable "auto_deployment" {
  description = "Configuration block containing the auto-deployment model for your StackSet. This can only be defined when using the SERVICE_MANAGED permission model."
  type = object({
    enabled                          = optional(bool)
    retain_stacks_on_account_removal = optional(bool)
  })
  default = null
}

variable "name" {
  description = "Name of the StackSet. The name must be unique in the region where you create your StackSet. The name can contain only alphanumeric characters (case-sensitive) and hyphens. It must start with an alphabetic character and cannot be longer than 128 characters."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.name)) && length(var.name) <= 128
    error_message = "resource_aws_cloudformation_stack_set, name must start with an alphabetic character, contain only alphanumeric characters and hyphens, and be no longer than 128 characters."
  }
}

variable "capabilities" {
  description = "A list of capabilities. Valid values: CAPABILITY_IAM, CAPABILITY_NAMED_IAM, CAPABILITY_AUTO_EXPAND."
  type        = list(string)
  default     = null

  validation {
    condition = var.capabilities == null || alltrue([
      for cap in var.capabilities : contains(["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"], cap)
    ])
    error_message = "resource_aws_cloudformation_stack_set, capabilities must contain only valid values: CAPABILITY_IAM, CAPABILITY_NAMED_IAM, CAPABILITY_AUTO_EXPAND."
  }
}

variable "operation_preferences" {
  description = "Preferences for how AWS CloudFormation performs a stack set update."
  type = object({
    failure_tolerance_count      = optional(number)
    failure_tolerance_percentage = optional(number)
    max_concurrent_count         = optional(number)
    max_concurrent_percentage    = optional(number)
    region_concurrency_type      = optional(string)
    region_order                 = optional(list(string))
  })
  default = null

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences.failure_tolerance_count == null ||
      (var.operation_preferences.failure_tolerance_count >= 0 && var.operation_preferences.failure_tolerance_count <= 2000)
    )
    error_message = "resource_aws_cloudformation_stack_set, failure_tolerance_count must be between 0 and 2000."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences.failure_tolerance_percentage == null ||
      (var.operation_preferences.failure_tolerance_percentage >= 0 && var.operation_preferences.failure_tolerance_percentage <= 100)
    )
    error_message = "resource_aws_cloudformation_stack_set, failure_tolerance_percentage must be between 0 and 100."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences.max_concurrent_count == null ||
      (var.operation_preferences.max_concurrent_count >= 1 && var.operation_preferences.max_concurrent_count <= 2000)
    )
    error_message = "resource_aws_cloudformation_stack_set, max_concurrent_count must be between 1 and 2000."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences.max_concurrent_percentage == null ||
      (var.operation_preferences.max_concurrent_percentage >= 1 && var.operation_preferences.max_concurrent_percentage <= 100)
    )
    error_message = "resource_aws_cloudformation_stack_set, max_concurrent_percentage must be between 1 and 100."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences.region_concurrency_type == null ||
      contains(["SEQUENTIAL", "PARALLEL"], var.operation_preferences.region_concurrency_type)
    )
    error_message = "resource_aws_cloudformation_stack_set, region_concurrency_type must be either SEQUENTIAL or PARALLEL."
  }
}

variable "description" {
  description = "Description of the StackSet."
  type        = string
  default     = null
}

variable "execution_role_name" {
  description = "Name of the IAM Role in all target accounts for StackSet operations. Defaults to AWSCloudFormationStackSetExecutionRole when using the SELF_MANAGED permission model. This should not be defined when using the SERVICE_MANAGED permission model."
  type        = string
  default     = null

  validation {
    condition     = var.execution_role_name == null || can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.execution_role_name))
    error_message = "resource_aws_cloudformation_stack_set, execution_role_name must contain only valid IAM role name characters."
  }
}

variable "managed_execution" {
  description = "Configuration block to allow StackSets to perform non-conflicting operations concurrently and queues conflicting operations."
  type = object({
    active = optional(bool)
  })
  default = null
}

variable "parameters" {
  description = "Key-value map of input parameters for the StackSet template. All template parameters, including those with a Default, must be configured or ignored with lifecycle configuration block ignore_changes argument."
  type        = map(string)
  default     = null
}

variable "permission_model" {
  description = "Describes how the IAM roles required for your StackSet are created. Valid values: SELF_MANAGED (default), SERVICE_MANAGED."
  type        = string
  default     = "SELF_MANAGED"

  validation {
    condition     = contains(["SELF_MANAGED", "SERVICE_MANAGED"], var.permission_model)
    error_message = "resource_aws_cloudformation_stack_set, permission_model must be either SELF_MANAGED or SERVICE_MANAGED."
  }
}

variable "call_as" {
  description = "Specifies whether you are acting as an account administrator in the organization's management account or as a delegated administrator in a member account. Valid values: SELF (default), DELEGATED_ADMIN."
  type        = string
  default     = "SELF"

  validation {
    condition     = contains(["SELF", "DELEGATED_ADMIN"], var.call_as)
    error_message = "resource_aws_cloudformation_stack_set, call_as must be either SELF or DELEGATED_ADMIN."
  }
}

variable "tags" {
  description = "Key-value map of tags to associate with this StackSet and the Stacks created from it. A maximum number of 50 tags can be specified."
  type        = map(string)
  default     = null

  validation {
    condition     = var.tags == null || length(var.tags) <= 50
    error_message = "resource_aws_cloudformation_stack_set, tags cannot exceed 50 tags."
  }
}

variable "template_body" {
  description = "String containing the CloudFormation template body. Maximum size: 51,200 bytes. Conflicts with template_url."
  type        = string
  default     = null

  validation {
    condition     = var.template_body == null || length(var.template_body) <= 51200
    error_message = "resource_aws_cloudformation_stack_set, template_body cannot exceed 51,200 bytes."
  }
}

variable "template_url" {
  description = "String containing the location of a file containing the CloudFormation template body. The URL must point to a template that is located in an Amazon S3 bucket. Maximum location file size: 460,800 bytes. Conflicts with template_body."
  type        = string
  default     = null

  validation {
    condition     = var.template_url == null || can(regex("^https?://", var.template_url))
    error_message = "resource_aws_cloudformation_stack_set, template_url must be a valid URL starting with http:// or https://."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_cloudformation_stack_set, timeouts_update must be a valid timeout format (e.g., 30m, 1h, 120s)."
  }
}