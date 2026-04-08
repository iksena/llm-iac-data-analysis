variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_servicequotas_service_quota, region must be a valid AWS region identifier or null"
  }
}

variable "service_code" {
  description = "Service code for the quota. Available values can be found with the aws_servicequotas_service data source or AWS CLI service-quotas list-services command."
  type        = string

  validation {
    condition     = length(var.service_code) > 0
    error_message = "data_aws_servicequotas_service_quota, service_code cannot be empty"
  }
}

variable "quota_code" {
  description = "Quota code within the service. When configured, the data source directly looks up the service quota. Available values can be found with the AWS CLI service-quotas list-service-quotas command. One of quota_code or quota_name must be specified."
  type        = string
  default     = null

  validation {
    condition     = var.quota_code == null || length(var.quota_code) > 0
    error_message = "data_aws_servicequotas_service_quota, quota_code cannot be empty if specified"
  }
}

variable "quota_name" {
  description = "Quota name within the service. When configured, the data source searches through all service quotas to find the matching quota name. Available values can be found with the AWS CLI service-quotas list-service-quotas command. One of quota_name or quota_code must be specified."
  type        = string
  default     = null

  validation {
    condition     = var.quota_name == null || length(var.quota_name) > 0
    error_message = "data_aws_servicequotas_service_quota, quota_name cannot be empty if specified"
  }

  validation {
    condition     = var.quota_code != null || var.quota_name != null
    error_message = "data_aws_servicequotas_service_quota, either quota_code or quota_name must be specified"
  }
}