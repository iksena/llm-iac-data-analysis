variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-\\d+$", var.region))
    error_message = "data_aws_apigatewayv2_vpc_link, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "vpc_link_id" {
  description = "VPC Link ID"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.vpc_link_id)) && length(var.vpc_link_id) > 0
    error_message = "data_aws_apigatewayv2_vpc_link, vpc_link_id must be a non-empty string containing only alphanumeric characters, hyphens, and underscores."
  }
}