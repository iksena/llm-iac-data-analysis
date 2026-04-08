variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "amount" {
  description = "The limit amount. If time-based, this amount is in Redshift Processing Units (RPU) consumed per hour. If data-based, this amount is in terabytes (TB) of data transferred between Regions in cross-account sharing. The value must be a positive number."
  type        = number

  validation {
    condition     = var.amount > 0
    error_message = "resource_aws_redshiftserverless_usage_limit, amount must be a positive number."
  }
}

variable "breach_action" {
  description = "The action that Amazon Redshift Serverless takes when the limit is reached. Valid values are log, emit-metric, and deactivate. The default is log."
  type        = string
  default     = "log"

  validation {
    condition     = contains(["log", "emit-metric", "deactivate"], var.breach_action)
    error_message = "resource_aws_redshiftserverless_usage_limit, breach_action must be one of: log, emit-metric, deactivate."
  }
}

variable "period" {
  description = "The time period that the amount applies to. A weekly period begins on Sunday. Valid values are daily, weekly, and monthly. The default is monthly."
  type        = string
  default     = "monthly"

  validation {
    condition     = contains(["daily", "weekly", "monthly"], var.period)
    error_message = "resource_aws_redshiftserverless_usage_limit, period must be one of: daily, weekly, monthly."
  }
}

variable "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the Amazon Redshift Serverless resource to create the usage limit for."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:redshift-serverless:", var.resource_arn))
    error_message = "resource_aws_redshiftserverless_usage_limit, resource_arn must be a valid Amazon Redshift Serverless ARN."
  }
}

variable "usage_type" {
  description = "The type of Amazon Redshift Serverless usage to create a usage limit for. Valid values are serverless-compute or cross-region-datasharing."
  type        = string

  validation {
    condition     = contains(["serverless-compute", "cross-region-datasharing"], var.usage_type)
    error_message = "resource_aws_redshiftserverless_usage_limit, usage_type must be one of: serverless-compute, cross-region-datasharing."
  }
}