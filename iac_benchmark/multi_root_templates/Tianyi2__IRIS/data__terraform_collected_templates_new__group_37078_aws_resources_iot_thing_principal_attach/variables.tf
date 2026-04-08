variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "principal" {
  description = "The AWS IoT Certificate ARN or Amazon Cognito Identity ID."
  type        = string

  validation {
    condition     = can(regex("^arn:aws", var.principal)) || can(regex("^[a-f0-9-]+", var.principal))
    error_message = "resource_aws_iot_thing_principal_attachment, principal must be a valid AWS IoT Certificate ARN or Amazon Cognito Identity ID."
  }
}

variable "thing" {
  description = "The name of the thing."
  type        = string

  validation {
    condition     = length(var.thing) > 0 && length(var.thing) <= 128
    error_message = "resource_aws_iot_thing_principal_attachment, thing name must be between 1 and 128 characters."
  }
}

variable "thing_principal_type" {
  description = "The type of relationship to specify when attaching a principal to a thing. Valid values are EXCLUSIVE_THING or NON_EXCLUSIVE_THING. Defaults to NON_EXCLUSIVE_THING."
  type        = string
  default     = "NON_EXCLUSIVE_THING"

  validation {
    condition     = contains(["EXCLUSIVE_THING", "NON_EXCLUSIVE_THING"], var.thing_principal_type)
    error_message = "resource_aws_iot_thing_principal_attachment, thing_principal_type must be either EXCLUSIVE_THING or NON_EXCLUSIVE_THING."
  }
}