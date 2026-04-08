variable "account_id" {
  description = "The ID of the target account for budget. Will use current user's account_id by default if omitted."
  type        = string
  default     = null
}

variable "billing_view_arn" {
  description = "ARN of the billing view."
  type        = string
  default     = null
}

variable "auto_adjust_data" {
  description = "Object containing AutoAdjustData which determines the budget amount for an auto-adjusting budget."
  type = object({
    auto_adjust_type      = string
    last_auto_adjust_time = optional(string)
    historical_options = optional(object({
      budget_adjustment_period   = number
      lookback_available_periods = optional(number)
    }))
  })
  default = null

  validation {
    condition     = var.auto_adjust_data == null || contains(["FORECAST", "HISTORICAL"], var.auto_adjust_data.auto_adjust_type)
    error_message = "resource_aws_budgets_budget, auto_adjust_data.auto_adjust_type must be either FORECAST or HISTORICAL."
  }

  validation {
    condition = var.auto_adjust_data == null || (
      var.auto_adjust_data.auto_adjust_type != "HISTORICAL" ||
      var.auto_adjust_data.historical_options != null
    )
    error_message = "resource_aws_budgets_budget, auto_adjust_data.historical_options is required when auto_adjust_type is HISTORICAL."
  }
}

variable "budget_type" {
  description = "Whether this budget tracks monetary cost or usage."
  type        = string

  validation {
    condition     = contains(["COST", "USAGE", "RI_UTILIZATION", "SAVINGS_PLANS_UTILIZATION"], var.budget_type)
    error_message = "resource_aws_budgets_budget, budget_type must be one of: COST, USAGE, RI_UTILIZATION, SAVINGS_PLANS_UTILIZATION."
  }
}

variable "cost_filter" {
  description = "A list of CostFilter name/values pair to apply to budget."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = null

  validation {
    condition = var.cost_filter == null || alltrue([
      for filter in var.cost_filter : contains([
        "AZ", "BillingEntity", "CostCategory", "InstanceType", "InvoicingEntity",
        "LegalEntityName", "LinkedAccount", "Operation", "PurchaseType", "Region",
        "Service", "TagKeyValue", "UsageType", "UsageTypeGroup"
      ], filter.name)
    ])
    error_message = "resource_aws_budgets_budget, cost_filter name must be one of: AZ, BillingEntity, CostCategory, InstanceType, InvoicingEntity, LegalEntityName, LinkedAccount, Operation, PurchaseType, Region, Service, TagKeyValue, UsageType, UsageTypeGroup."
  }
}

variable "cost_types" {
  description = "Object containing CostTypes The types of cost included in a budget, such as tax and subscriptions."
  type = object({
    include_credit             = optional(bool, true)
    include_discount           = optional(bool, true)
    include_other_subscription = optional(bool, true)
    include_recurring          = optional(bool, true)
    include_refund             = optional(bool, true)
    include_subscription       = optional(bool, true)
    include_support            = optional(bool, true)
    include_tax                = optional(bool, true)
    include_upfront            = optional(bool, true)
    use_amortized              = optional(bool, false)
    use_blended                = optional(bool, false)
  })
  default = null
}

variable "limit_amount" {
  description = "The amount of cost or usage being measured for a budget."
  type        = string
  default     = null
}

variable "limit_unit" {
  description = "The unit of measurement used for the budget forecast, actual spend, or budget threshold, such as dollars or GB."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of a budget. Unique within accounts."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "The prefix of the name of a budget. Unique within accounts."
  type        = string
  default     = null
}

variable "notification" {
  description = "Object containing Budget Notifications. Can be used multiple times to define more than one budget notification."
  type = list(object({
    comparison_operator        = string
    threshold                  = number
    threshold_type             = string
    notification_type          = string
    subscriber_email_addresses = optional(list(string))
    subscriber_sns_topic_arns  = optional(list(string))
  }))
  default = null

  validation {
    condition = var.notification == null || alltrue([
      for notif in var.notification : contains(["LESS_THAN", "EQUAL_TO", "GREATER_THAN"], notif.comparison_operator)
    ])
    error_message = "resource_aws_budgets_budget, notification.comparison_operator must be one of: LESS_THAN, EQUAL_TO, GREATER_THAN."
  }

  validation {
    condition = var.notification == null || alltrue([
      for notif in var.notification : contains(["PERCENTAGE", "ABSOLUTE_VALUE"], notif.threshold_type)
    ])
    error_message = "resource_aws_budgets_budget, notification.threshold_type must be one of: PERCENTAGE, ABSOLUTE_VALUE."
  }

  validation {
    condition = var.notification == null || alltrue([
      for notif in var.notification : contains(["ACTUAL", "FORECASTED"], notif.notification_type)
    ])
    error_message = "resource_aws_budgets_budget, notification.notification_type must be one of: ACTUAL, FORECASTED."
  }

  validation {
    condition = var.notification == null || alltrue([
      for notif in var.notification : (
        (notif.subscriber_email_addresses != null && length(notif.subscriber_email_addresses) > 0) ||
        (notif.subscriber_sns_topic_arns != null && length(notif.subscriber_sns_topic_arns) > 0)
      )
    ])
    error_message = "resource_aws_budgets_budget, notification must have either subscriber_email_addresses or subscriber_sns_topic_arns specified."
  }
}

variable "planned_limit" {
  description = "Object containing Planned Budget Limits. Can be used multiple times to plan more than one budget limit."
  type = list(object({
    start_time = string
    amount     = string
    unit       = string
  }))
  default = null
}

variable "tags" {
  description = "Map of tags assigned to the resource."
  type        = map(string)
  default     = {}
}

variable "time_period_end" {
  description = "The end of the time period covered by the budget. Format: 2017-01-01_12:00."
  type        = string
  default     = null

  validation {
    condition     = var.time_period_end == null || can(regex("^\\d{4}-\\d{2}-\\d{2}_\\d{2}:\\d{2}$", var.time_period_end))
    error_message = "resource_aws_budgets_budget, time_period_end must be in format YYYY-MM-DD_HH:MM."
  }
}

variable "time_period_start" {
  description = "The start of the time period covered by the budget. Format: 2017-01-01_12:00."
  type        = string
  default     = null

  validation {
    condition     = var.time_period_start == null || can(regex("^\\d{4}-\\d{2}-\\d{2}_\\d{2}:\\d{2}$", var.time_period_start))
    error_message = "resource_aws_budgets_budget, time_period_start must be in format YYYY-MM-DD_HH:MM."
  }
}

variable "time_unit" {
  description = "The length of time until a budget resets the actual and forecasted spend."
  type        = string

  validation {
    condition     = contains(["MONTHLY", "QUARTERLY", "ANNUALLY", "DAILY"], var.time_unit)
    error_message = "resource_aws_budgets_budget, time_unit must be one of: MONTHLY, QUARTERLY, ANNUALLY, DAILY."
  }
}