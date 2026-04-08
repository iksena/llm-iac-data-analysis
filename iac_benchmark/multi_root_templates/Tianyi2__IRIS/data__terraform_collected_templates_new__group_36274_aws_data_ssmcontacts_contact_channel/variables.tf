variable "arn" {
  description = "Amazon Resource Name (ARN) of the contact channel"
  type        = string
  validation {
    condition     = can(regex("^arn:aws:ssm-contacts:", var.arn))
    error_message = "data_aws_ssmcontacts_contact_channel, arn must be a valid SSM Contacts contact channel ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
  validation {
    condition     = var.region == null || can(regex("^[a-z][a-z0-9-]+[a-z0-9]$", var.region))
    error_message = "data_aws_ssmcontacts_contact_channel, region must be a valid AWS region identifier."
  }
}