variable "arn" {
  description = "The Amazon Resource Name (ARN) of the rotation."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ssm-contacts:", var.arn))
    error_message = "data_aws_ssmcontacts_rotation, arn must be a valid SSM Contacts rotation ARN starting with 'arn:aws:ssm-contacts:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ssmcontacts_rotation, region must be a valid AWS region identifier or null."
  }
}