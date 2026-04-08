variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_vpc_endpoint_policy, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}

variable "vpc_endpoint_id" {
  description = "The VPC Endpoint ID."
  type        = string

  validation {
    condition     = can(regex("^vpce-[0-9a-f]{8}([0-9a-f]{9})?$", var.vpc_endpoint_id))
    error_message = "resource_aws_vpc_endpoint_policy, vpc_endpoint_id must be a valid VPC endpoint ID format (e.g., vpce-12345678 or vpce-123456789abcdef01)."
  }
}

variable "policy" {
  description = "A policy to attach to the endpoint that controls access to the service. Defaults to full access. All Gateway and some Interface endpoints support policies."
  type        = string
  default     = null

  validation {
    condition     = var.policy == null || can(jsondecode(var.policy))
    error_message = "resource_aws_vpc_endpoint_policy, policy must be a valid JSON string or null."
  }
}