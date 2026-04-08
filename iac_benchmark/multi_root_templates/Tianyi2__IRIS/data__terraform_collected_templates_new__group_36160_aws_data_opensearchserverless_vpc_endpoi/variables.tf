variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_opensearchserverless_vpc_endpoint, region must be a valid AWS region identifier or null."
  }
}

variable "vpc_endpoint_id" {
  description = "The unique identifier of the endpoint."
  type        = string

  validation {
    condition     = can(regex("^vpce-[a-z0-9]+$", var.vpc_endpoint_id))
    error_message = "data_aws_opensearchserverless_vpc_endpoint, vpc_endpoint_id must be a valid VPC endpoint ID starting with 'vpce-'."
  }
}