variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "destination" {
  description = "The target Region or Availability Zone that the metric subscription is enabled for. For example, eu-west-1."
  type        = string

  validation {
    condition     = var.destination != null && var.destination != ""
    error_message = "resource_aws_vpc_network_performance_metric_subscription, destination must be a non-empty string."
  }
}

variable "metric" {
  description = "The metric used for the enabled subscription. Valid values: aggregate-latency. Default: aggregate-latency."
  type        = string
  default     = "aggregate-latency"

  validation {
    condition     = contains(["aggregate-latency"], var.metric)
    error_message = "resource_aws_vpc_network_performance_metric_subscription, metric must be one of: aggregate-latency."
  }
}

variable "source_region" {
  description = "The source Region or Availability Zone that the metric subscription is enabled for. For example, us-east-1."
  type        = string

  validation {
    condition     = var.source_region != null && var.source_region != ""
    error_message = "resource_aws_vpc_network_performance_metric_subscription, source_region must be a non-empty string."
  }
}

variable "statistic" {
  description = "The statistic used for the enabled subscription. Valid values: p50. Default: p50."
  type        = string
  default     = "p50"

  validation {
    condition     = contains(["p50"], var.statistic)
    error_message = "resource_aws_vpc_network_performance_metric_subscription, statistic must be one of: p50."
  }
}