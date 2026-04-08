variable "arn" {
  description = "ARN of the infrastructure configuration"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:imagebuilder:[a-z0-9-]+:[0-9]+:infrastructure-configuration/[a-zA-Z0-9-_.]+$", var.arn))
    error_message = "data_aws_imagebuilder_infrastructure_configuration, arn must be a valid AWS ImageBuilder Infrastructure Configuration ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_imagebuilder_infrastructure_configuration, region must be a valid AWS region identifier or null."
  }
}