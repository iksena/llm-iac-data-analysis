variable "account_id" {
  description = "The ID of the target account for budget. Will use current user's account_id by default if omitted."
  type        = string
  default     = null
}

variable "budget_name" {
  description = "The name of a budget."
  type        = string

  validation {
    condition     = length(var.budget_name) > 0
    error_message = "resource_aws_budgets_budget_action, budget_name cannot be empty."
  }
}

variable "action_threshold" {
  description = "The trigger threshold of the action."
  type = object({
    action_threshold_type  = string
    action_threshold_value = number
  })

  validation {
    condition     = contains(["PERCENTAGE", "ABSOLUTE_VALUE"], var.action_threshold.action_threshold_type)
    error_message = "resource_aws_budgets_budget_action, action_threshold.action_threshold_type must be either 'PERCENTAGE' or 'ABSOLUTE_VALUE'."
  }

  validation {
    condition     = var.action_threshold.action_threshold_value >= 0
    error_message = "resource_aws_budgets_budget_action, action_threshold.action_threshold_value must be a non-negative number."
  }
}

variable "action_type" {
  description = "The type of action. This defines the type of tasks that can be carried out by this action. This field also determines the format for definition."
  type        = string

  validation {
    condition     = contains(["APPLY_IAM_POLICY", "APPLY_SCP_POLICY", "RUN_SSM_DOCUMENTS"], var.action_type)
    error_message = "resource_aws_budgets_budget_action, action_type must be one of 'APPLY_IAM_POLICY', 'APPLY_SCP_POLICY', or 'RUN_SSM_DOCUMENTS'."
  }
}

variable "approval_model" {
  description = "This specifies if the action needs manual or automatic approval."
  type        = string

  validation {
    condition     = contains(["AUTOMATIC", "MANUAL"], var.approval_model)
    error_message = "resource_aws_budgets_budget_action, approval_model must be either 'AUTOMATIC' or 'MANUAL'."
  }
}

variable "definition" {
  description = "Specifies all of the type-specific parameters."
  type = object({
    iam_action_definition = optional(object({
      policy_arn = string
      groups     = optional(list(string))
      roles      = optional(list(string))
      users      = optional(list(string))
    }))
    scp_action_definition = optional(object({
      policy_id  = string
      target_ids = optional(list(string))
    }))
    ssm_action_definition = optional(object({
      action_sub_type = string
      instance_ids    = list(string)
      region          = string
    }))
  })

  validation {
    condition = (
      (var.definition.iam_action_definition != null ? 1 : 0) +
      (var.definition.scp_action_definition != null ? 1 : 0) +
      (var.definition.ssm_action_definition != null ? 1 : 0)
    ) == 1
    error_message = "resource_aws_budgets_budget_action, definition must contain exactly one of iam_action_definition, scp_action_definition, or ssm_action_definition."
  }

  validation {
    condition = var.definition.iam_action_definition == null || (
      var.definition.iam_action_definition.policy_arn != null &&
      length(var.definition.iam_action_definition.policy_arn) > 0
    )
    error_message = "resource_aws_budgets_budget_action, definition.iam_action_definition.policy_arn is required when iam_action_definition is specified."
  }

  validation {
    condition = var.definition.iam_action_definition == null || (
      (var.definition.iam_action_definition.groups != null && length(var.definition.iam_action_definition.groups) > 0) ||
      (var.definition.iam_action_definition.roles != null && length(var.definition.iam_action_definition.roles) > 0) ||
      (var.definition.iam_action_definition.users != null && length(var.definition.iam_action_definition.users) > 0)
    )
    error_message = "resource_aws_budgets_budget_action, definition.iam_action_definition must have at least one of groups, roles, or users specified."
  }

  validation {
    condition = var.definition.scp_action_definition == null || (
      var.definition.scp_action_definition.policy_id != null &&
      length(var.definition.scp_action_definition.policy_id) > 0
    )
    error_message = "resource_aws_budgets_budget_action, definition.scp_action_definition.policy_id is required when scp_action_definition is specified."
  }

  validation {
    condition = var.definition.ssm_action_definition == null || (
      contains(["STOP_EC2_INSTANCES", "STOP_RDS_INSTANCES"], var.definition.ssm_action_definition.action_sub_type)
    )
    error_message = "resource_aws_budgets_budget_action, definition.ssm_action_definition.action_sub_type must be either 'STOP_EC2_INSTANCES' or 'STOP_RDS_INSTANCES'."
  }

  validation {
    condition = var.definition.ssm_action_definition == null || (
      var.definition.ssm_action_definition.instance_ids != null &&
      length(var.definition.ssm_action_definition.instance_ids) > 0
    )
    error_message = "resource_aws_budgets_budget_action, definition.ssm_action_definition.instance_ids is required and must not be empty."
  }

  validation {
    condition = var.definition.ssm_action_definition == null || (
      var.definition.ssm_action_definition.region != null &&
      length(var.definition.ssm_action_definition.region) > 0
    )
    error_message = "resource_aws_budgets_budget_action, definition.ssm_action_definition.region is required and must not be empty."
  }
}

variable "execution_role_arn" {
  description = "The role passed for action execution and reversion. Roles and actions must be in the same account."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", var.execution_role_arn))
    error_message = "resource_aws_budgets_budget_action, execution_role_arn must be a valid IAM role ARN."
  }
}

variable "notification_type" {
  description = "The type of a notification."
  type        = string

  validation {
    condition     = contains(["ACTUAL", "FORECASTED"], var.notification_type)
    error_message = "resource_aws_budgets_budget_action, notification_type must be either 'ACTUAL' or 'FORECASTED'."
  }
}

variable "subscriber" {
  description = "A list of subscribers."
  type = list(object({
    address           = string
    subscription_type = string
  }))

  validation {
    condition     = length(var.subscriber) > 0
    error_message = "resource_aws_budgets_budget_action, subscriber list must not be empty."
  }

  validation {
    condition = alltrue([
      for s in var.subscriber : contains(["SNS", "EMAIL"], s.subscription_type)
    ])
    error_message = "resource_aws_budgets_budget_action, subscriber.subscription_type must be either 'SNS' or 'EMAIL' for all subscribers."
  }

  validation {
    condition = alltrue([
      for s in var.subscriber : length(s.address) > 0
    ])
    error_message = "resource_aws_budgets_budget_action, subscriber.address must not be empty for all subscribers."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
  })
  default = {}
}