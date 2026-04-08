variable "arn" {
  description = "ARN of the component"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:imagebuilder:[^:]*:[^:]*:component/[^/]+/[^/]+$", var.arn))
    error_message = "data_aws_imagebuilder_component, arn must be a valid Image Builder Component ARN in format: arn:aws:imagebuilder:region:account:component/name/version"
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_imagebuilder_component, region must be a valid AWS region identifier"
  }
}