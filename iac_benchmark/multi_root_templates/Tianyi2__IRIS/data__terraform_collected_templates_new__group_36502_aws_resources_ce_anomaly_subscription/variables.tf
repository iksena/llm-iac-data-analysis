variable "account_id" {
  description = "The unique identifier for the AWS account in which the anomaly subscription ought to be created"
  type        = string
  default     = null
}

variable "frequency" {
  description = "The frequency that anomaly reports are sent"
  type        = string

  validation {
    condition     = contains(["DAILY", "IMMEDIATE", "WEEKLY"], var.frequency)
    error_message = "resource_aws_ce_anomaly_subscription, frequency must be one of: DAILY, IMMEDIATE, WEEKLY."
  }
}

variable "monitor_arn_list" {
  description = "A list of cost anomaly monitors"
  type        = list(string)

  validation {
    condition     = length(var.monitor_arn_list) > 0
    error_message = "resource_aws_ce_anomaly_subscription, monitor_arn_list must contain at least one monitor ARN."
  }
}

variable "name" {
  description = "The name for the subscription"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ce_anomaly_subscription, name cannot be empty."
  }
}

variable "subscriber" {
  description = "A subscriber configuration. Multiple subscribers can be defined"
  type = list(object({
    type    = string
    address = string
  }))

  validation {
    condition = alltrue([
      for s in var.subscriber : contains(["SNS", "EMAIL"], s.type)
    ])
    error_message = "resource_aws_ce_anomaly_subscription, subscriber type must be either SNS or EMAIL."
  }

  validation {
    condition = alltrue([
      for s in var.subscriber : length(s.address) > 0
    ])
    error_message = "resource_aws_ce_anomaly_subscription, subscriber address cannot be empty."
  }

  validation {
    condition     = length(var.subscriber) > 0
    error_message = "resource_aws_ce_anomaly_subscription, subscriber must contain at least one subscriber."
  }
}

variable "threshold_expression" {
  description = "An Expression object used to specify the anomalies that you want to generate alerts for"
  type = object({
    and = optional(list(object({
      cost_category = optional(object({
        key           = optional(string)
        match_options = optional(list(string))
        values        = optional(list(string))
      }))
      dimension = optional(object({
        key           = optional(string)
        match_options = optional(list(string))
        values        = optional(list(string))
      }))
      tags = optional(object({
        key           = optional(string)
        match_options = optional(list(string))
        values        = optional(list(string))
      }))
    })))
    cost_category = optional(object({
      key           = optional(string)
      match_options = optional(list(string))
      values        = optional(list(string))
    }))
    dimension = optional(object({
      key           = optional(string)
      match_options = optional(list(string))
      values        = optional(list(string))
    }))
    not = optional(list(object({
      cost_category = optional(object({
        key           = optional(string)
        match_options = optional(list(string))
        values        = optional(list(string))
      }))
      dimension = optional(object({
        key           = optional(string)
        match_options = optional(list(string))
        values        = optional(list(string))
      }))
      tags = optional(object({
        key           = optional(string)
        match_options = optional(list(string))
        values        = optional(list(string))
      }))
    })))
    or = optional(list(object({
      cost_category = optional(object({
        key           = optional(string)
        match_options = optional(list(string))
        values        = optional(list(string))
      }))
      dimension = optional(object({
        key           = optional(string)
        match_options = optional(list(string))
        values        = optional(list(string))
      }))
      tags = optional(object({
        key           = optional(string)
        match_options = optional(list(string))
        values        = optional(list(string))
      }))
    })))
    tags = optional(object({
      key           = optional(string)
      match_options = optional(list(string))
      values        = optional(list(string))
    }))
  })
  default = null

  validation {
    condition = var.threshold_expression == null ? true : alltrue([
      for and_block in coalesce(var.threshold_expression.and, []) :
      and_block.cost_category != null ? alltrue([
        for match_option in coalesce(and_block.cost_category.match_options, []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]) : true
    ])
    error_message = "resource_aws_ce_anomaly_subscription, threshold_expression and cost_category match_options must be one of: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = var.threshold_expression == null ? true : alltrue([
      for and_block in coalesce(var.threshold_expression.and, []) :
      and_block.dimension != null ? alltrue([
        for match_option in coalesce(and_block.dimension.match_options, []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]) : true
    ])
    error_message = "resource_aws_ce_anomaly_subscription, threshold_expression and dimension match_options must be one of: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = var.threshold_expression == null ? true : alltrue([
      for and_block in coalesce(var.threshold_expression.and, []) :
      and_block.tags != null ? alltrue([
        for match_option in coalesce(and_block.tags.match_options, []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]) : true
    ])
    error_message = "resource_aws_ce_anomaly_subscription, threshold_expression and tags match_options must be one of: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = var.threshold_expression == null ? true : (
      var.threshold_expression.cost_category != null ? alltrue([
        for match_option in coalesce(var.threshold_expression.cost_category.match_options, []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]) : true
    )
    error_message = "resource_aws_ce_anomaly_subscription, threshold_expression cost_category match_options must be one of: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = var.threshold_expression == null ? true : (
      var.threshold_expression.dimension != null ? alltrue([
        for match_option in coalesce(var.threshold_expression.dimension.match_options, []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]) : true
    )
    error_message = "resource_aws_ce_anomaly_subscription, threshold_expression dimension match_options must be one of: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = var.threshold_expression == null ? true : (
      var.threshold_expression.tags != null ? alltrue([
        for match_option in coalesce(var.threshold_expression.tags.match_options, []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]) : true
    )
    error_message = "resource_aws_ce_anomaly_subscription, threshold_expression tags match_options must be one of: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = var.threshold_expression == null ? true : alltrue([
      for not_block in coalesce(var.threshold_expression.not, []) :
      not_block.cost_category != null ? alltrue([
        for match_option in coalesce(not_block.cost_category.match_options, []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]) : true
    ])
    error_message = "resource_aws_ce_anomaly_subscription, threshold_expression not cost_category match_options must be one of: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = var.threshold_expression == null ? true : alltrue([
      for not_block in coalesce(var.threshold_expression.not, []) :
      not_block.dimension != null ? alltrue([
        for match_option in coalesce(not_block.dimension.match_options, []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]) : true
    ])
    error_message = "resource_aws_ce_anomaly_subscription, threshold_expression not dimension match_options must be one of: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = var.threshold_expression == null ? true : alltrue([
      for not_block in coalesce(var.threshold_expression.not, []) :
      not_block.tags != null ? alltrue([
        for match_option in coalesce(not_block.tags.match_options, []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]) : true
    ])
    error_message = "resource_aws_ce_anomaly_subscription, threshold_expression not tags match_options must be one of: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = var.threshold_expression == null ? true : alltrue([
      for or_block in coalesce(var.threshold_expression.or, []) :
      or_block.cost_category != null ? alltrue([
        for match_option in coalesce(or_block.cost_category.match_options, []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]) : true
    ])
    error_message = "resource_aws_ce_anomaly_subscription, threshold_expression or cost_category match_options must be one of: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = var.threshold_expression == null ? true : alltrue([
      for or_block in coalesce(var.threshold_expression.or, []) :
      or_block.dimension != null ? alltrue([
        for match_option in coalesce(or_block.dimension.match_options, []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]) : true
    ])
    error_message = "resource_aws_ce_anomaly_subscription, threshold_expression or dimension match_options must be one of: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = var.threshold_expression == null ? true : alltrue([
      for or_block in coalesce(var.threshold_expression.or, []) :
      or_block.tags != null ? alltrue([
        for match_option in coalesce(or_block.tags.match_options, []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]) : true
    ])
    error_message = "resource_aws_ce_anomaly_subscription, threshold_expression or tags match_options must be one of: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}