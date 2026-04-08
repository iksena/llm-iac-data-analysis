variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_servicequotas_service, region must be a valid AWS region format."
  }
}

variable "service_name" {
  type        = string
  description = "Service name to lookup within Service Quotas. Available values can be found with the AWS CLI service-quotas list-services command."

  validation {
    condition     = length(var.service_name) > 0
    error_message = "data_aws_servicequotas_service, service_name cannot be empty."
  }
}