variable "service_id" {
  description = "ID of the endpoint service."
  type        = string

  validation {
    condition     = can(regex("^vpce-svc-[0-9a-f]{8}([0-9a-f]{9})?$", var.service_id))
    error_message = "resource_aws_vpc_endpoint_service_private_dns_verification, service_id must be a valid VPC endpoint service ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_vpc_endpoint_service_private_dns_verification, region must be a valid AWS region format (e.g., us-west-2)."
  }
}

variable "wait_for_verification" {
  description = "Whether to wait until the endpoint service returns a Verified status for the configured private DNS name."
  type        = bool
  default     = null
}

variable "create_timeout" {
  description = "Timeout for create operation."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_vpc_endpoint_service_private_dns_verification, create_timeout must be a valid duration (e.g., 30m, 1h, 300s)."
  }
}