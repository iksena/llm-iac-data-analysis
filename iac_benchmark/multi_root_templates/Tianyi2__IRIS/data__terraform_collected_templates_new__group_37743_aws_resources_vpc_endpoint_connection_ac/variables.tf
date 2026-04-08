variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}(-gov)?-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_vpc_endpoint_connection_accepter, region must be a valid AWS region format (e.g., us-east-1, eu-west-1, us-gov-west-1) or null."
  }
}

variable "vpc_endpoint_id" {
  description = "AWS VPC Endpoint ID."
  type        = string

  validation {
    condition     = can(regex("^vpce-[a-f0-9]{8}([a-f0-9]{9})?$", var.vpc_endpoint_id))
    error_message = "resource_aws_vpc_endpoint_connection_accepter, vpc_endpoint_id must be a valid VPC Endpoint ID starting with 'vpce-'."
  }
}

variable "vpc_endpoint_service_id" {
  description = "AWS VPC Endpoint Service ID."
  type        = string

  validation {
    condition     = can(regex("^vpce-svc-[a-f0-9]{8}([a-f0-9]{9})?$", var.vpc_endpoint_service_id))
    error_message = "resource_aws_vpc_endpoint_connection_accepter, vpc_endpoint_service_id must be a valid VPC Endpoint Service ID starting with 'vpce-svc-'."
  }
}