variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the policy"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_autoscaling_policy, name must not be empty."
  }
}

variable "autoscaling_group_name" {
  description = "Name of the autoscaling group"
  type        = string

  validation {
    condition     = length(var.autoscaling_group_name) > 0
    error_message = "resource_aws_autoscaling_policy, autoscaling_group_name must not be empty."
  }
}

variable "adjustment_type" {
  description = "Whether the adjustment is an absolute number or a percentage of the current capacity"
  type        = string
  default     = null

  validation {
    condition = var.adjustment_type == null || contains([
      "ChangeInCapacity",
      "ExactCapacity",
      "PercentChangeInCapacity"
    ], var.adjustment_type)
    error_message = "resource_aws_autoscaling_policy, adjustment_type must be one of: ChangeInCapacity, ExactCapacity, PercentChangeInCapacity."
  }
}

variable "policy_type" {
  description = "Policy type"
  type        = string
  default     = null

  validation {
    condition = var.policy_type == null || contains([
      "SimpleScaling",
      "StepScaling",
      "TargetTrackingScaling",
      "PredictiveScaling"
    ], var.policy_type)
    error_message = "resource_aws_autoscaling_policy, policy_type must be one of: SimpleScaling, StepScaling, TargetTrackingScaling, PredictiveScaling."
  }
}

variable "estimated_instance_warmup" {
  description = "Estimated time, in seconds, until a newly launched instance will contribute CloudWatch metrics"
  type        = number
  default     = null

  validation {
    condition     = var.estimated_instance_warmup == null || var.estimated_instance_warmup >= 0
    error_message = "resource_aws_autoscaling_policy, estimated_instance_warmup must be greater than or equal to 0."
  }
}

variable "enabled" {
  description = "Whether the scaling policy is enabled or disabled"
  type        = bool
  default     = true
}

variable "min_adjustment_magnitude" {
  description = "Minimum value to scale by when adjustment_type is set to PercentChangeInCapacity"
  type        = number
  default     = null

  validation {
    condition     = var.min_adjustment_magnitude == null || var.min_adjustment_magnitude > 0
    error_message = "resource_aws_autoscaling_policy, min_adjustment_magnitude must be greater than 0."
  }
}

variable "cooldown" {
  description = "Amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start"
  type        = number
  default     = null

  validation {
    condition     = var.cooldown == null || var.cooldown >= 0
    error_message = "resource_aws_autoscaling_policy, cooldown must be greater than or equal to 0."
  }
}

variable "scaling_adjustment" {
  description = "Number of instances by which to scale"
  type        = number
  default     = null
}

variable "metric_aggregation_type" {
  description = "Aggregation type for the policy's metrics"
  type        = string
  default     = null

  validation {
    condition = var.metric_aggregation_type == null || contains([
      "Minimum",
      "Maximum",
      "Average"
    ], var.metric_aggregation_type)
    error_message = "resource_aws_autoscaling_policy, metric_aggregation_type must be one of: Minimum, Maximum, Average."
  }
}

variable "step_adjustment" {
  description = "Set of adjustments that manage group scaling"
  type = list(object({
    scaling_adjustment          = number
    metric_interval_lower_bound = optional(number)
    metric_interval_upper_bound = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for adjustment in var.step_adjustment :
      adjustment.metric_interval_upper_bound == null ||
      adjustment.metric_interval_lower_bound == null ||
      adjustment.metric_interval_upper_bound > adjustment.metric_interval_lower_bound
    ])
    error_message = "resource_aws_autoscaling_policy, step_adjustment metric_interval_upper_bound must be greater than metric_interval_lower_bound."
  }
}

variable "target_tracking_configuration" {
  description = "Target tracking policy configuration"
  type = object({
    target_value     = number
    disable_scale_in = optional(bool)
    predefined_metric_specification = optional(object({
      predefined_metric_type = string
      resource_label         = optional(string)
    }))
    customized_metric_specification = optional(object({
      metric_name = optional(string)
      namespace   = optional(string)
      period      = optional(number)
      statistic   = optional(string)
      unit        = optional(string)
      metric_dimension = optional(list(object({
        name  = string
        value = string
      })))
      metrics = optional(list(object({
        id          = string
        expression  = optional(string)
        label       = optional(string)
        return_data = optional(bool)
        metric_stat = optional(object({
          period = optional(number)
          stat   = string
          unit   = optional(string)
          metric = object({
            metric_name = string
            namespace   = string
            dimensions = optional(list(object({
              name  = string
              value = string
            })))
          })
        }))
      })))
    }))
  })
  default = null

  validation {
    condition = var.target_tracking_configuration == null || (
      var.target_tracking_configuration.predefined_metric_specification == null ||
      var.target_tracking_configuration.customized_metric_specification == null
    )
    error_message = "resource_aws_autoscaling_policy, target_tracking_configuration cannot have both predefined_metric_specification and customized_metric_specification."
  }

  validation {
    condition     = var.target_tracking_configuration == null || var.target_tracking_configuration.target_value > 0
    error_message = "resource_aws_autoscaling_policy, target_tracking_configuration target_value must be greater than 0."
  }
}

variable "predictive_scaling_configuration" {
  description = "Predictive scaling policy configuration"
  type = object({
    max_capacity_breach_behavior = optional(string)
    max_capacity_buffer          = optional(number)
    mode                         = optional(string)
    scheduling_buffer_time       = optional(number)
    metric_specification = object({
      target_value = number
      predefined_load_metric_specification = optional(object({
        predefined_metric_type = string
        resource_label         = string
      }))
      predefined_metric_pair_specification = optional(object({
        predefined_metric_type = string
        resource_label         = string
      }))
      predefined_scaling_metric_specification = optional(object({
        predefined_metric_type = string
        resource_label         = string
      }))
      customized_scaling_metric_specification = optional(object({
        metric_data_queries = list(object({
          id          = string
          expression  = optional(string)
          label       = optional(string)
          return_data = optional(bool)
          metric_stat = optional(object({
            stat = string
            unit = optional(string)
            metric = object({
              metric_name = string
              namespace   = string
              dimensions = optional(list(object({
                name  = string
                value = string
              })))
            })
          }))
        }))
      }))
      customized_load_metric_specification = optional(object({
        metric_data_queries = list(object({
          id          = string
          expression  = optional(string)
          label       = optional(string)
          return_data = optional(bool)
          metric_stat = optional(object({
            stat = string
            unit = optional(string)
            metric = object({
              metric_name = string
              namespace   = string
              dimensions = optional(list(object({
                name  = string
                value = string
              })))
            })
          }))
        }))
      }))
      customized_capacity_metric_specification = optional(object({
        metric_data_queries = list(object({
          id          = string
          expression  = optional(string)
          label       = optional(string)
          return_data = optional(bool)
          metric_stat = optional(object({
            stat = string
            unit = optional(string)
            metric = object({
              metric_name = string
              namespace   = string
              dimensions = optional(list(object({
                name  = string
                value = string
              })))
            })
          }))
        }))
      }))
    })
  })
  default = null

  validation {
    condition = var.predictive_scaling_configuration == null || (
      var.predictive_scaling_configuration.max_capacity_breach_behavior == null ||
      contains(["HonorMaxCapacity", "IncreaseMaxCapacity"], var.predictive_scaling_configuration.max_capacity_breach_behavior)
    )
    error_message = "resource_aws_autoscaling_policy, predictive_scaling_configuration max_capacity_breach_behavior must be HonorMaxCapacity or IncreaseMaxCapacity."
  }

  validation {
    condition = var.predictive_scaling_configuration == null || (
      var.predictive_scaling_configuration.max_capacity_buffer == null ||
      (var.predictive_scaling_configuration.max_capacity_buffer >= 0 && var.predictive_scaling_configuration.max_capacity_buffer <= 100)
    )
    error_message = "resource_aws_autoscaling_policy, predictive_scaling_configuration max_capacity_buffer must be between 0 and 100."
  }

  validation {
    condition = var.predictive_scaling_configuration == null || (
      var.predictive_scaling_configuration.mode == null ||
      contains(["ForecastAndScale", "ForecastOnly"], var.predictive_scaling_configuration.mode)
    )
    error_message = "resource_aws_autoscaling_policy, predictive_scaling_configuration mode must be ForecastAndScale or ForecastOnly."
  }

  validation {
    condition = var.predictive_scaling_configuration == null || (
      var.predictive_scaling_configuration.scheduling_buffer_time == null ||
      var.predictive_scaling_configuration.scheduling_buffer_time >= 0
    )
    error_message = "resource_aws_autoscaling_policy, predictive_scaling_configuration scheduling_buffer_time must be greater than or equal to 0."
  }
}