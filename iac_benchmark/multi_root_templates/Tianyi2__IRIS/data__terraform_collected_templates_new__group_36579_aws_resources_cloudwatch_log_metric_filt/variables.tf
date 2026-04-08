variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "A name for the metric filter."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_cloudwatch_log_metric_filter, name must not be empty."
  }
}

variable "pattern" {
  description = "A valid CloudWatch Logs filter pattern for extracting metric data out of ingested log events."
  type        = string

  validation {
    condition     = var.pattern != null
    error_message = "resource_aws_cloudwatch_log_metric_filter, pattern is required."
  }
}

variable "log_group_name" {
  description = "The name of the log group to associate the metric filter with."
  type        = string

  validation {
    condition     = length(var.log_group_name) > 0
    error_message = "resource_aws_cloudwatch_log_metric_filter, log_group_name must not be empty."
  }
}

variable "metric_transformation" {
  description = "A block defining collection of information needed to define how metric data gets emitted."
  type = object({
    name          = string
    namespace     = string
    value         = string
    default_value = optional(string)
    dimensions    = optional(map(string))
    unit          = optional(string)
  })

  validation {
    condition     = length(var.metric_transformation.name) > 0
    error_message = "resource_aws_cloudwatch_log_metric_filter, metric_transformation.name must not be empty."
  }

  validation {
    condition     = length(var.metric_transformation.namespace) > 0
    error_message = "resource_aws_cloudwatch_log_metric_filter, metric_transformation.namespace must not be empty."
  }

  validation {
    condition     = length(var.metric_transformation.value) > 0
    error_message = "resource_aws_cloudwatch_log_metric_filter, metric_transformation.value must not be empty."
  }

  validation {
    condition = !(
      var.metric_transformation.default_value != null &&
      var.metric_transformation.dimensions != null
    )
    error_message = "resource_aws_cloudwatch_log_metric_filter, metric_transformation.default_value conflicts with metric_transformation.dimensions."
  }

  validation {
    condition     = var.metric_transformation.dimensions == null || length(var.metric_transformation.dimensions) <= 3
    error_message = "resource_aws_cloudwatch_log_metric_filter, metric_transformation.dimensions can have up to 3 dimensions."
  }
}

variable "apply_on_transformed_logs" {
  description = "Whether the metric filter will be applied on the transformed version of the log events instead of the original ingested log events. Defaults to false. Valid only for log groups that have an active log transformer."
  type        = bool
  default     = false
}