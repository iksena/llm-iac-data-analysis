variable "arn" {
  description = "ARN of the distribution configuration"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:imagebuilder:", var.arn))
    error_message = "data_aws_imagebuilder_distribution_configuration, arn must be a valid Image Builder distribution configuration ARN starting with 'arn:aws:imagebuilder:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_imagebuilder_distribution_configuration, region must be a valid AWS region name (e.g., us-west-2) or null."
  }
}