variable "arn" {
  description = "ARN of the VPC Connection"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kafka:", var.arn))
    error_message = "data_aws_msk_vpc_connection, arn must be a valid MSK VPC connection ARN starting with 'arn:aws:kafka:'"
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_msk_vpc_connection, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)"
  }
}