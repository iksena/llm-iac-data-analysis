variable "aws_region" {
  description = "AWS Region to which the template applies"
  type        = string
  default     = null
}

variable "region" {
  description = "AWS Region to which the template applies. Use aws_region instead"
  type        = string
  default     = null
}

variable "quota_code" {
  description = "Quota identifier. To find the quota code for a specific quota, use the aws_servicequotas_service_quota data source"
  type        = string

  validation {
    condition     = length(var.quota_code) > 0
    error_message = "resource_aws_servicequotas_template, quota_code must not be empty."
  }
}

variable "service_code" {
  description = "Service identifier. To find the service code value for an AWS service, use the aws_servicequotas_service data source"
  type        = string

  validation {
    condition     = length(var.service_code) > 0
    error_message = "resource_aws_servicequotas_template, service_code must not be empty."
  }
}

variable "value" {
  description = "The new, increased value for the quota"
  type        = string

  validation {
    condition     = length(var.value) > 0
    error_message = "resource_aws_servicequotas_template, value must not be empty."
  }

  validation {
    condition     = can(tonumber(var.value))
    error_message = "resource_aws_servicequotas_template, value must be a valid number."
  }
}