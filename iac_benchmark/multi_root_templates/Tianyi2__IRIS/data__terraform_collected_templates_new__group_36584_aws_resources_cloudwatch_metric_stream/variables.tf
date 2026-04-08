variable "firehose_arn" {
  description = "ARN of the Amazon Kinesis Firehose delivery stream to use for this metric stream"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:firehose:", var.firehose_arn))
    error_message = "resource_aws_cloudwatch_metric_stream, firehose_arn must be a valid Amazon Kinesis Firehose delivery stream ARN starting with 'arn:aws:firehose:'."
  }
}

variable "role_arn" {
  description = "ARN of the IAM role that this metric stream will use to access Amazon Kinesis Firehose resources"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam:", var.role_arn))
    error_message = "resource_aws_cloudwatch_metric_stream, role_arn must be a valid IAM role ARN starting with 'arn:aws:iam:'."
  }
}

variable "output_format" {
  description = "Output format for the stream. Possible values are json, opentelemetry0.7, and opentelemetry1.0"
  type        = string

  validation {
    condition     = contains(["json", "opentelemetry0.7", "opentelemetry1.0"], var.output_format)
    error_message = "resource_aws_cloudwatch_metric_stream, output_format must be one of: json, opentelemetry0.7, opentelemetry1.0."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "exclude_filter" {
  description = "List of exclusive metric filters. If you specify this parameter, the stream sends metrics from all metric namespaces except for the namespaces and the conditional metric names that you specify here"
  type = list(object({
    namespace    = string
    metric_names = optional(list(string))
  }))
  default = null
}

variable "include_filter" {
  description = "List of inclusive metric filters. If you specify this parameter, the stream sends only the conditional metric names from the metric namespaces that you specify here"
  type = list(object({
    namespace    = string
    metric_names = optional(list(string))
  }))
  default = null
}

variable "name" {
  description = "Friendly name of the metric stream. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique friendly name beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "statistics_configuration" {
  description = "For each entry in this array, you specify one or more metrics and the list of additional statistics to stream for those metrics"
  type = list(object({
    additional_statistics = list(string)
    include_metric = list(object({
      metric_name = string
      namespace   = string
    }))
  }))
  default = null

  validation {
    condition = var.statistics_configuration == null || alltrue([
      for config in var.statistics_configuration : length(config.additional_statistics) > 0
    ])
    error_message = "resource_aws_cloudwatch_metric_stream, statistics_configuration additional_statistics cannot be empty when statistics_configuration is specified."
  }

  validation {
    condition = var.statistics_configuration == null || alltrue([
      for config in var.statistics_configuration : length(config.include_metric) > 0
    ])
    error_message = "resource_aws_cloudwatch_metric_stream, statistics_configuration include_metric cannot be empty when statistics_configuration is specified."
  }
}

variable "include_linked_accounts_metrics" {
  description = "If you are creating a metric stream in a monitoring account, specify true to include metrics from source accounts that are linked to this monitoring account, in the metric stream"
  type        = bool
  default     = false
}