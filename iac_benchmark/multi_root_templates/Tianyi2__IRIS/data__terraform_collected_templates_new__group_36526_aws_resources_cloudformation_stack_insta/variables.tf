variable "stack_set_name" {
  description = "Name of the stack set."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.stack_set_name))
    error_message = "resource_cloudformation_stack_instances, stack_set_name must start with a letter and can only contain alphanumeric characters and hyphens."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "accounts" {
  description = "Accounts where you want to create stack instances in the specified regions. You can specify either accounts or deployment_targets, but not both."
  type        = list(string)
  default     = null

  validation {
    condition = var.accounts == null || (
      var.accounts != null &&
      length(var.accounts) > 0 &&
      alltrue([for account in var.accounts : can(regex("^[0-9]{12}$", account))])
    )
    error_message = "resource_cloudformation_stack_instances, accounts must be a list of valid 12-digit AWS account IDs."
  }

  validation {
    condition     = !(var.accounts != null && var.deployment_targets != null)
    error_message = "resource_cloudformation_stack_instances, accounts and deployment_targets cannot both be specified - they are mutually exclusive."
  }
}

variable "deployment_targets" {
  description = "AWS Organizations accounts for which to create stack instances in the regions."
  type = object({
    account_filter_type     = optional(string)
    accounts                = optional(list(string))
    accounts_url            = optional(string)
    organizational_unit_ids = optional(list(string))
  })
  default = null

  validation {
    condition = var.deployment_targets == null || (
      var.deployment_targets != null &&
      (var.deployment_targets.account_filter_type == null ||
      contains(["INTERSECTION", "DIFFERENCE", "UNION", "NONE"], var.deployment_targets.account_filter_type))
    )
    error_message = "resource_cloudformation_stack_instances, deployment_targets account_filter_type must be one of: INTERSECTION, DIFFERENCE, UNION, NONE."
  }

  validation {
    condition = var.deployment_targets == null || (
      var.deployment_targets != null &&
      (var.deployment_targets.accounts == null ||
        (length(var.deployment_targets.accounts) > 0 &&
      alltrue([for account in var.deployment_targets.accounts : can(regex("^[0-9]{12}$", account))])))
    )
    error_message = "resource_cloudformation_stack_instances, deployment_targets accounts must be a list of valid 12-digit AWS account IDs."
  }

  validation {
    condition = var.deployment_targets == null || (
      var.deployment_targets != null &&
      (var.deployment_targets.accounts_url == null ||
      can(regex("^s3://", var.deployment_targets.accounts_url)))
    )
    error_message = "resource_cloudformation_stack_instances, deployment_targets accounts_url must be a valid S3 URL starting with s3://."
  }
}

variable "parameter_overrides" {
  description = "Key-value map of input parameters to override from the stack set for these instances."
  type        = map(string)
  default     = null
}

variable "regions" {
  description = "Regions where you want to create stack instances in the specified accounts."
  type        = list(string)
  default     = null

  validation {
    condition = var.regions == null || (
      var.regions != null &&
      length(var.regions) > 0 &&
      alltrue([for region in var.regions : can(regex("^[a-z0-9-]+$", region))])
    )
    error_message = "resource_cloudformation_stack_instances, regions must be a list of valid AWS region names."
  }
}

variable "retain_stacks" {
  description = "Whether to remove the stack instances from the stack set, but not delete the stacks. Defaults to false."
  type        = bool
  default     = false
}

variable "call_as" {
  description = "Whether you are acting as an account administrator in the organization's management account or as a delegated administrator in a member account."
  type        = string
  default     = "SELF"

  validation {
    condition     = contains(["SELF", "DELEGATED_ADMIN"], var.call_as)
    error_message = "resource_cloudformation_stack_instances, call_as must be either SELF or DELEGATED_ADMIN."
  }
}

variable "operation_preferences" {
  description = "Preferences for how AWS CloudFormation performs a stack set operation."
  type = object({
    concurrency_mode             = optional(string)
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
      var.operation_preferences != null &&
      (var.operation_preferences.concurrency_mode == null ||
      contains(["STRICT_FAILURE_TOLERANCE", "SOFT_FAILURE_TOLERANCE"], var.operation_preferences.concurrency_mode))
    )
    error_message = "resource_cloudformation_stack_instances, operation_preferences concurrency_mode must be either STRICT_FAILURE_TOLERANCE or SOFT_FAILURE_TOLERANCE."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences != null &&
      (var.operation_preferences.failure_tolerance_count == null ||
      var.operation_preferences.failure_tolerance_count >= 0)
    )
    error_message = "resource_cloudformation_stack_instances, operation_preferences failure_tolerance_count must be a non-negative number."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences != null &&
      (var.operation_preferences.failure_tolerance_percentage == null ||
      (var.operation_preferences.failure_tolerance_percentage >= 0 && var.operation_preferences.failure_tolerance_percentage <= 100))
    )
    error_message = "resource_cloudformation_stack_instances, operation_preferences failure_tolerance_percentage must be between 0 and 100."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences != null &&
      (var.operation_preferences.max_concurrent_count == null ||
      var.operation_preferences.max_concurrent_count > 0)
    )
    error_message = "resource_cloudformation_stack_instances, operation_preferences max_concurrent_count must be a positive number."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences != null &&
      (var.operation_preferences.max_concurrent_percentage == null ||
      (var.operation_preferences.max_concurrent_percentage > 0 && var.operation_preferences.max_concurrent_percentage <= 100))
    )
    error_message = "resource_cloudformation_stack_instances, operation_preferences max_concurrent_percentage must be between 1 and 100."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences != null &&
      (var.operation_preferences.region_concurrency_type == null ||
      contains(["SEQUENTIAL", "PARALLEL"], var.operation_preferences.region_concurrency_type))
    )
    error_message = "resource_cloudformation_stack_instances, operation_preferences region_concurrency_type must be either SEQUENTIAL or PARALLEL."
  }

  validation {
    condition = var.operation_preferences == null || (
      var.operation_preferences != null &&
      (var.operation_preferences.region_order == null ||
        (length(var.operation_preferences.region_order) > 0 &&
      alltrue([for region in var.operation_preferences.region_order : can(regex("^[a-z0-9-]+$", region))])))
    )
    error_message = "resource_cloudformation_stack_instances, operation_preferences region_order must be a list of valid AWS region names."
  }
}

