variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the usage plan."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_api_gateway_usage_plan, name must not be empty."
  }
}

variable "description" {
  description = "Description of a usage plan."
  type        = string
  default     = null
}

variable "api_stages" {
  description = "Associated API stages of the usage plan."
  type = list(object({
    api_id = string
    stage  = string
    throttle = optional(object({
      path        = string
      burst_limit = optional(number)
      rate_limit  = optional(number)
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for stage in var.api_stages : length(stage.api_id) > 0
    ])
    error_message = "resource_aws_api_gateway_usage_plan, api_id must not be empty for all api_stages."
  }

  validation {
    condition = alltrue([
      for stage in var.api_stages : length(stage.stage) > 0
    ])
    error_message = "resource_aws_api_gateway_usage_plan, stage must not be empty for all api_stages."
  }

  validation {
    condition = alltrue([
      for stage in var.api_stages :
      stage.throttle == null ? true : length(stage.throttle.path) > 0
    ])
    error_message = "resource_aws_api_gateway_usage_plan, path must not be empty when throttle is specified in api_stages."
  }

  validation {
    condition = alltrue([
      for stage in var.api_stages :
      stage.throttle == null ? true : (
        stage.throttle.burst_limit == null ? true : stage.throttle.burst_limit >= 0
      )
    ])
    error_message = "resource_aws_api_gateway_usage_plan, burst_limit must be >= 0 when specified in api_stages throttle."
  }

  validation {
    condition = alltrue([
      for stage in var.api_stages :
      stage.throttle == null ? true : (
        stage.throttle.rate_limit == null ? true : stage.throttle.rate_limit >= 0
      )
    ])
    error_message = "resource_aws_api_gateway_usage_plan, rate_limit must be >= 0 when specified in api_stages throttle."
  }
}

variable "quota_settings" {
  description = "The quota settings of the usage plan."
  type = object({
    limit  = optional(number)
    offset = optional(number)
    period = optional(string)
  })
  default = null

  validation {
    condition = var.quota_settings == null ? true : (
      var.quota_settings.limit == null ? true : var.quota_settings.limit >= 0
    )
    error_message = "resource_aws_api_gateway_usage_plan, limit must be >= 0 when specified in quota_settings."
  }

  validation {
    condition = var.quota_settings == null ? true : (
      var.quota_settings.offset == null ? true : var.quota_settings.offset >= 0
    )
    error_message = "resource_aws_api_gateway_usage_plan, offset must be >= 0 when specified in quota_settings."
  }

  validation {
    condition = var.quota_settings == null ? true : (
      var.quota_settings.period == null ? true : contains(["DAY", "WEEK", "MONTH"], var.quota_settings.period)
    )
    error_message = "resource_aws_api_gateway_usage_plan, period must be one of: DAY, WEEK, MONTH when specified in quota_settings."
  }
}

variable "throttle_settings" {
  description = "The throttling limits of the usage plan."
  type = object({
    burst_limit = optional(number)
    rate_limit  = optional(number)
  })
  default = null

  validation {
    condition = var.throttle_settings == null ? true : (
      var.throttle_settings.burst_limit == null ? true : var.throttle_settings.burst_limit >= 0
    )
    error_message = "resource_aws_api_gateway_usage_plan, burst_limit must be >= 0 when specified in throttle_settings."
  }

  validation {
    condition = var.throttle_settings == null ? true : (
      var.throttle_settings.rate_limit == null ? true : var.throttle_settings.rate_limit >= 0
    )
    error_message = "resource_aws_api_gateway_usage_plan, rate_limit must be >= 0 when specified in throttle_settings."
  }
}

variable "product_code" {
  description = "AWS Marketplace product identifier to associate with the usage plan as a SaaS product on AWS Marketplace."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}