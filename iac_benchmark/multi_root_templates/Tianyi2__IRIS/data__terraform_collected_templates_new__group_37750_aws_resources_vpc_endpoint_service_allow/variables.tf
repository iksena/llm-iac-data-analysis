variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_endpoint_service_id" {
  description = "The ID of the VPC endpoint service to allow permission."
  type        = string

  validation {
    condition     = can(regex("^vpce-svc-[0-9a-f]{8,17}$", var.vpc_endpoint_service_id))
    error_message = "resource_aws_vpc_endpoint_service_allowed_principal, vpc_endpoint_service_id must be a valid VPC endpoint service ID starting with 'vpce-svc-'."
  }
}

variable "principal_arn" {
  description = "The ARN of the principal to allow permissions."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:[a-zA-Z0-9-_]+:[a-zA-Z0-9-_]*:[0-9]{12}:.*$", var.principal_arn))
    error_message = "resource_aws_vpc_endpoint_service_allowed_principal, principal_arn must be a valid AWS ARN format."
  }
}