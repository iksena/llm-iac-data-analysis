variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "amount" {
  description = "The limit amount. If time-based, this amount is in minutes. If data-based, this amount is in terabytes (TB). The value must be a positive number."
  type        = number

  validation {
    condition     = var.amount > 0
    error_message = "resource_aws_redshift_usage_limit, amount must be a positive number."
  }
}

variable "breach_action" {
  description = "The action that Amazon Redshift takes when the limit is reached. The default is log."
  type        = string
  default     = "log"

  validation {
    condition     = contains(["log", "emit-metric", "disable"], var.breach_action)
    error_message = "resource_aws_redshift_usage_limit, breach_action must be one of: log, emit-metric, disable."
  }
}

variable "cluster_identifier" {
  description = "The identifier of the cluster that you want to limit usage."
  type        = string
}

variable "feature_type" {
  description = "The Amazon Redshift feature that you want to limit."
  type        = string

  validation {
    condition     = contains(["spectrum", "concurrency-scaling", "cross-region-datasharing"], var.feature_type)
    error_message = "resource_aws_redshift_usage_limit, feature_type must be one of: spectrum, concurrency-scaling, cross-region-datasharing."
  }
}

variable "limit_type" {
  description = "The type of limit. Depending on the feature type, this can be based on a time duration or data size."
  type        = string

  validation {
    condition     = contains(["data-scanned", "time"], var.limit_type)
    error_message = "resource_aws_redshift_usage_limit, limit_type must be one of: data-scanned, time."
  }

  validation {
    condition = (
      (var.feature_type == "spectrum" && var.limit_type == "data-scanned") ||
      (var.feature_type == "concurrency-scaling" && var.limit_type == "time") ||
      (var.feature_type == "cross-region-datasharing" && var.limit_type == "data-scanned")
    )
    error_message = "resource_aws_redshift_usage_limit, limit_type must be 'data-scanned' for spectrum and cross-region-datasharing features, and 'time' for concurrency-scaling feature."
  }
}

variable "period" {
  description = "The time period that the amount applies to. A weekly period begins on Sunday. The default is monthly."
  type        = string
  default     = "monthly"

  validation {
    condition     = contains(["daily", "weekly", "monthly"], var.period)
    error_message = "resource_aws_redshift_usage_limit, period must be one of: daily, weekly, monthly."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}