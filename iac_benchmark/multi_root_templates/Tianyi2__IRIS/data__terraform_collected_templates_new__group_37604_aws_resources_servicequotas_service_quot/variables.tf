variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_servicequotas_service_quota, region must be a valid AWS region identifier or null."
  }
}

variable "quota_code" {
  description = "Code of the service quota to track. For example: L-F678F1CE. Available values can be found with the AWS CLI service-quotas list-service-quotas command."
  type        = string

  validation {
    condition     = can(regex("^L-[A-Z0-9]+$", var.quota_code))
    error_message = "resource_aws_servicequotas_service_quota, quota_code must be in the format L-XXXXXXXX where X is alphanumeric."
  }
}

variable "service_code" {
  description = "Code of the service to track. For example: vpc. Available values can be found with the AWS CLI service-quotas list-services command."
  type        = string

  validation {
    condition     = length(var.service_code) > 0
    error_message = "resource_aws_servicequotas_service_quota, service_code cannot be empty."
  }
}

variable "value" {
  description = "Float specifying the desired value for the service quota. If the desired value is higher than the current value, a quota increase request is submitted. When a known request is submitted and pending, the value reflects the desired value of the pending request."
  type        = number

  validation {
    condition     = var.value > 0
    error_message = "resource_aws_servicequotas_service_quota, value must be greater than 0."
  }
}