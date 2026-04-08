variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_vpc_endpoint_associations, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "vpc_endpoint_id" {
  description = "ID of the specific VPC Endpoint to retrieve."
  type        = string

  validation {
    condition     = can(regex("^vpce-[0-9a-f]{8,17}$", var.vpc_endpoint_id))
    error_message = "data_aws_vpc_endpoint_associations, vpc_endpoint_id must be a valid VPC Endpoint ID (format: vpce-xxxxxxxx)."
  }
}