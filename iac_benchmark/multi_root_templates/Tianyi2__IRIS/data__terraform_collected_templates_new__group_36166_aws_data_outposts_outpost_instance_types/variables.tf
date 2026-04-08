variable "arn" {
  type        = string
  description = "Outpost ARN"

  validation {
    condition     = can(regex("^arn:aws:outposts:", var.arn))
    error_message = "data_aws_outposts_outpost_instance_types, arn must be a valid Outpost ARN starting with 'arn:aws:outposts:'."
  }
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_outposts_outpost_instance_types, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}