variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the policy. Must be between 1 and 255 characters in length."
  type        = string
  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "resource_aws_appautoscaling_policy, name must be between 1 and 255 characters in length."
  }
}

variable "policy_type" {
  description = "Policy type. Valid values are StepScaling, TargetTrackingScaling, and PredictiveScaling. Defaults to StepScaling."
  type        = string
  default     = "StepScaling"
  validation {
    condition     = contains(["StepScaling", "TargetTrackingScaling", "PredictiveScaling"], var.policy_type)
    error_message = "resource_aws_appautoscaling_policy, policy_type must be one of: StepScaling, TargetTrackingScaling, PredictiveScaling."
  }
}

variable "resource_id" {
  description = "Resource type and unique identifier string for the resource associated with the scaling policy."
  type        = string
}

variable "scalable_dimension" {
  description = "Scalable dimension of the scalable target."
  type        = string
}

variable "service_namespace" {
  description = "AWS service namespace of the scalable target."
  type        = string
}

variable "step_scaling_policy_configuration" {
  description = "Step scaling policy configuration, requires policy_type = StepScaling (default)."
  type = object({
    adjustment_type          = string
    cooldown                 = number
    metric_aggregation_type  = optional(string)
    min_adjustment_magnitude = optional(number)
    step_adjustment = optional(list(object({
      metric_interval_lower_bound = optional(number)
      metric_interval_upper_bound = optional(number)
      scaling_adjustment          = number
    })))
  })
  default = null
  validation {
    condition = var.step_scaling_policy_configuration == null || (
      var.step_scaling_policy_configuration != null &&
      contains(["ChangeInCapacity", "ExactCapacity", "PercentChangeInCapacity"], var.step_scaling_policy_configuration.adjustment_type)
    )
    error_message = "resource_aws_appautoscaling_policy, adjustment_type must be one of: ChangeInCapacity, ExactCapacity, PercentChangeInCapacity."
  }
  validation {
    condition = var.step_scaling_policy_configuration == null || (
      var.step_scaling_policy_configuration != null &&
      var.step_scaling_policy_configuration.metric_aggregation_type == null ||
      contains(["Minimum", "Maximum", "Average"], var.step_scaling_policy_configuration.metric_aggregation_type)
    )
    error_message = "resource_aws_appautoscaling_policy, metric_aggregation_type must be one of: Minimum, Maximum, Average."
  }
}

variable "target_tracking_scaling_policy_configuration" {
  description = "Target tracking policy configuration, requires policy_type = TargetTrackingScaling."
  type = object({
    target_value       = number
    disable_scale_in   = optional(bool, false)
    scale_in_cooldown  = optional(number)
    scale_out_cooldown = optional(number)
    customized_metric_specification = optional(object({
      metric_name = optional(string)
      namespace   = optional(string)
      statistic   = optional(string)
      unit        = optional(string)
      dimensions = optional(list(object({
        name  = string
        value = string
      })))
      metrics = optional(list(object({
        expression  = optional(string)
        id          = string
        label       = optional(string)
        return_data = optional(bool, true)
        metric_stat = optional(object({
          metric = object({
            metric_name = string
            namespace   = string
            dimensions = optional(list(object({
              name  = string
              value = string
            })))
          })
          stat = string
          unit = optional(string)
        }))
      })))
    }))
    predefined_metric_specification = optional(object({
      predefined_metric_type = string
      resource_label         = optional(string)
    }))
  })
  default = null
  validation {
    condition = var.target_tracking_scaling_policy_configuration == null || (
      var.target_tracking_scaling_policy_configuration != null &&
      var.target_tracking_scaling_policy_configuration.customized_metric_specification == null ||
      var.target_tracking_scaling_policy_configuration.customized_metric_specification.statistic == null ||
      contains(["Average", "Minimum", "Maximum", "SampleCount", "Sum"], var.target_tracking_scaling_policy_configuration.customized_metric_specification.statistic)
    )
    error_message = "resource_aws_appautoscaling_policy, statistic must be one of: Average, Minimum, Maximum, SampleCount, Sum."
  }
  validation {
    condition = var.target_tracking_scaling_policy_configuration == null || (
      var.target_tracking_scaling_policy_configuration != null &&
      var.target_tracking_scaling_policy_configuration.predefined_metric_specification == null ||
      var.target_tracking_scaling_policy_configuration.predefined_metric_specification.resource_label == null ||
      length(var.target_tracking_scaling_policy_configuration.predefined_metric_specification.resource_label) <= 1023
    )
    error_message = "resource_aws_appautoscaling_policy, resource_label must be less than or equal to 1023 characters in length."
  }
}

variable "predictive_scaling_policy_configuration" {
  description = "Predictive scaling policy configuration, requires policy_type = PredictiveScaling."
  type = object({
    max_capacity_breach_behavior = optional(string)
    max_capacity_buffer          = optional(number)
    mode                         = optional(string)
    scheduling_buffer_time       = optional(number)
    metric_specification = object({
      target_value = number
      customized_capacity_metric_specification = optional(object({
        metric_data_query = list(object({
          expression  = optional(string)
          id          = string
          label       = optional(string)
          return_data = optional(bool)
          metric_stat = optional(object({
            stat = string
            unit = optional(string)
            metric = object({
              metric_name = optional(string)
              namespace   = optional(string)
              dimensions = optional(list(object({
                name  = optional(string)
                value = optional(string)
              })))
            })
          }))
        }))
      }))
      customized_load_metric_specification = optional(object({
        metric_data_query = list(object({
          expression  = optional(string)
          id          = string
          label       = optional(string)
          return_data = optional(bool)
          metric_stat = optional(object({
            stat = string
            unit = optional(string)
            metric = object({
              metric_name = optional(string)
              namespace   = optional(string)
              dimensions = optional(list(object({
                name  = optional(string)
                value = optional(string)
              })))
            })
          }))
        }))
      }))
      customized_scaling_metric_specification = optional(object({
        metric_data_query = list(object({
          expression  = optional(string)
          id          = string
          label       = optional(string)
          return_data = optional(bool)
          metric_stat = optional(object({
            stat = string
            unit = optional(string)
            metric = object({
              metric_name = optional(string)
              namespace   = optional(string)
              dimensions = optional(list(object({
                name  = optional(string)
                value = optional(string)
              })))
            })
          }))
        }))
      }))
      predefined_load_metric_specification = optional(object({
        predefined_metric_type = string
        resource_label         = optional(string)
      }))
      predefined_metric_pair_specification = optional(object({
        predefined_metric_type = string
        resource_label         = optional(string)
      }))
      predefined_scaling_metric_specification = optional(object({
        predefined_metric_type = string
        resource_label         = optional(string)
      }))
    })
  })
  default = null
  validation {
    condition = var.predictive_scaling_policy_configuration == null || (
      var.predictive_scaling_policy_configuration != null &&
      var.predictive_scaling_policy_configuration.max_capacity_breach_behavior == null ||
      contains(["HonorMaxCapacity", "IncreaseMaxCapacity"], var.predictive_scaling_policy_configuration.max_capacity_breach_behavior)
    )
    error_message = "resource_aws_appautoscaling_policy, max_capacity_breach_behavior must be one of: HonorMaxCapacity, IncreaseMaxCapacity."
  }
  validation {
    condition = var.predictive_scaling_policy_configuration == null || (
      var.predictive_scaling_policy_configuration != null &&
      var.predictive_scaling_policy_configuration.mode == null ||
      contains(["ForecastOnly", "ForecastAndScale"], var.predictive_scaling_policy_configuration.mode)
    )
    error_message = "resource_aws_appautoscaling_policy, mode must be one of: ForecastOnly, ForecastAndScale."
  }
}