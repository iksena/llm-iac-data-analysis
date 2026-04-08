variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "alarm_name" {
  description = "The descriptive name for the alarm. This name must be unique within the user's AWS account"
  type        = string

  validation {
    condition     = length(var.alarm_name) > 0
    error_message = "resource_aws_cloudwatch_metric_alarm, alarm_name must not be empty."
  }
}

variable "comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold"
  type        = string

  validation {
    condition = contains([
      "GreaterThanOrEqualToThreshold",
      "GreaterThanThreshold",
      "LessThanThreshold",
      "LessThanOrEqualToThreshold",
      "LessThanLowerOrGreaterThanUpperThreshold",
      "LessThanLowerThreshold",
      "GreaterThanUpperThreshold"
    ], var.comparison_operator)
    error_message = "resource_aws_cloudwatch_metric_alarm, comparison_operator must be one of: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold, LessThanLowerOrGreaterThanUpperThreshold, LessThanLowerThreshold, or GreaterThanUpperThreshold."
  }
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold"
  type        = number

  validation {
    condition     = var.evaluation_periods > 0
    error_message = "resource_aws_cloudwatch_metric_alarm, evaluation_periods must be greater than 0."
  }
}

variable "metric_name" {
  description = "The name for the alarm's associated metric"
  type        = string
  default     = null
}

variable "namespace" {
  description = "The namespace for the alarm's associated metric"
  type        = string
  default     = null
}

variable "period" {
  description = "The period in seconds over which the specified statistic is applied"
  type        = number
  default     = null

  validation {
    condition = var.period == null ? true : (
      var.period == 10 || var.period == 20 || var.period == 30 || var.period % 60 == 0
    )
    error_message = "resource_aws_cloudwatch_metric_alarm, period must be 10, 20, 30, or any multiple of 60."
  }
}

variable "statistic" {
  description = "The statistic to apply to the alarm's associated metric"
  type        = string
  default     = null

  validation {
    condition = var.statistic == null ? true : contains([
      "SampleCount",
      "Average",
      "Sum",
      "Minimum",
      "Maximum"
    ], var.statistic)
    error_message = "resource_aws_cloudwatch_metric_alarm, statistic must be one of: SampleCount, Average, Sum, Minimum, or Maximum."
  }
}

variable "threshold" {
  description = "The value against which the specified statistic is compared"
  type        = number
  default     = null
}

variable "threshold_metric_id" {
  description = "If this is an alarm based on an anomaly detection model, make this value match the ID of the ANOMALY_DETECTION_BAND function"
  type        = string
  default     = null
}

variable "actions_enabled" {
  description = "Indicates whether or not actions should be executed during any changes to the alarm's state"
  type        = bool
  default     = true
}

variable "alarm_actions" {
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state"
  type        = list(string)
  default     = []
}

variable "alarm_description" {
  description = "The description for the alarm"
  type        = string
  default     = null
}

variable "datapoints_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm"
  type        = number
  default     = null

  validation {
    condition     = var.datapoints_to_alarm == null ? true : var.datapoints_to_alarm > 0
    error_message = "resource_aws_cloudwatch_metric_alarm, datapoints_to_alarm must be greater than 0."
  }
}

variable "dimensions" {
  description = "The dimensions for the alarm's associated metric"
  type        = map(string)
  default     = {}
}

variable "insufficient_data_actions" {
  description = "The list of actions to execute when this alarm transitions into an INSUFFICIENT_DATA state from any other state"
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "The list of actions to execute when this alarm transitions into an OK state from any other state"
  type        = list(string)
  default     = []
}

variable "unit" {
  description = "The unit for the alarm's associated metric"
  type        = string
  default     = null
}

variable "extended_statistic" {
  description = "The percentile statistic for the metric associated with the alarm. Specify a value between p0.0 and p100"
  type        = string
  default     = null

  validation {
    condition = var.extended_statistic == null ? true : (
      can(regex("^p([0-9]|[1-9][0-9]|100)(\\.[0-9]+)?$", var.extended_statistic))
    )
    error_message = "resource_aws_cloudwatch_metric_alarm, extended_statistic must be a percentile value between p0.0 and p100."
  }
}

variable "treat_missing_data" {
  description = "Sets how this alarm is to handle missing data points"
  type        = string
  default     = "missing"

  validation {
    condition = contains([
      "missing",
      "ignore",
      "breaching",
      "notBreaching"
    ], var.treat_missing_data)
    error_message = "resource_aws_cloudwatch_metric_alarm, treat_missing_data must be one of: missing, ignore, breaching, or notBreaching."
  }
}

variable "evaluate_low_sample_count_percentiles" {
  description = "Used only for alarms based on percentiles. If you specify ignore, the alarm state will not change during periods with too few data points to be statistically significant"
  type        = string
  default     = null

  validation {
    condition = var.evaluate_low_sample_count_percentiles == null ? true : contains([
      "ignore",
      "evaluate"
    ], var.evaluate_low_sample_count_percentiles)
    error_message = "resource_aws_cloudwatch_metric_alarm, evaluate_low_sample_count_percentiles must be either ignore or evaluate."
  }
}

variable "metric_query" {
  description = "Enables you to create an alarm based on a metric math expression. You may specify at most 20"
  type = list(object({
    id          = string
    account_id  = optional(string)
    expression  = optional(string)
    label       = optional(string)
    period      = optional(number)
    return_data = optional(bool)
    metric = optional(object({
      dimensions  = optional(map(string))
      metric_name = string
      namespace   = string
      period      = number
      stat        = string
      unit        = optional(string)
    }))
  }))
  default = []

  validation {
    condition     = length(var.metric_query) <= 20
    error_message = "resource_aws_cloudwatch_metric_alarm, metric_query can have at most 20 items."
  }

  validation {
    condition = alltrue([
      for mq in var.metric_query : can(regex("^[a-z][a-zA-Z0-9_]*$", mq.id))
    ])
    error_message = "resource_aws_cloudwatch_metric_alarm, metric_query id must contain only letters, numbers, and underscore, and must start with a lowercase letter."
  }

  validation {
    condition = alltrue([
      for mq in var.metric_query :
      (mq.expression != null && mq.metric == null) ||
      (mq.expression == null && mq.metric != null)
    ])
    error_message = "resource_aws_cloudwatch_metric_alarm, metric_query must specify either expression or metric, but not both."
  }

  validation {
    condition = alltrue([
      for mq in var.metric_query :
      mq.period == null ? true : (
        mq.period == 1 || mq.period == 5 || mq.period == 10 ||
        mq.period == 20 || mq.period == 30 || mq.period % 60 == 0
      )
    ])
    error_message = "resource_aws_cloudwatch_metric_alarm, metric_query period must be 1, 5, 10, 20, 30, or any multiple of 60."
  }

  validation {
    condition = alltrue([
      for mq in var.metric_query :
      mq.metric == null ? true : (
        mq.metric.period == 1 || mq.metric.period == 5 || mq.metric.period == 10 ||
        mq.metric.period == 20 || mq.metric.period == 30 || mq.metric.period % 60 == 0
      )
    ])
    error_message = "resource_aws_cloudwatch_metric_alarm, metric_query metric period must be 1, 5, 10, 20, 30, or any multiple of 60."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}