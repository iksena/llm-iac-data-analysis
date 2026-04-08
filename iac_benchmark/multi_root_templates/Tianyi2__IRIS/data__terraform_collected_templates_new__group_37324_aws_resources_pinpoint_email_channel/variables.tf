variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "application_id" {
  description = "The application ID."
  type        = string

  validation {
    condition     = length(var.application_id) > 0
    error_message = "resource_aws_pinpoint_email_channel, application_id must not be empty."
  }
}

variable "enabled" {
  description = "Whether the channel is enabled or disabled."
  type        = bool
  default     = true
}

variable "configuration_set" {
  description = "The ARN of the Amazon SES configuration set that you want to apply to messages that you send through the channel."
  type        = string
  default     = null

  validation {
    condition     = var.configuration_set == null || can(regex("^arn:aws:ses:", var.configuration_set))
    error_message = "resource_aws_pinpoint_email_channel, configuration_set must be a valid SES configuration set ARN."
  }
}

variable "from_address" {
  description = "The email address used to send emails from. You can use email only (user@example.com) or friendly address (User <user@example.com>). This field comply with RFC 5322."
  type        = string

  validation {
    condition     = length(var.from_address) > 0 && can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$|^[^<>]+<[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}>$", var.from_address))
    error_message = "resource_aws_pinpoint_email_channel, from_address must be a valid email address format complying with RFC 5322."
  }
}

variable "identity" {
  description = "The ARN of an identity verified with SES."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ses:", var.identity))
    error_message = "resource_aws_pinpoint_email_channel, identity must be a valid SES identity ARN."
  }
}

variable "orchestration_sending_role_arn" {
  description = "The ARN of an IAM role for Amazon Pinpoint to use to send email from your campaigns or journeys through Amazon SES."
  type        = string
  default     = null

  validation {
    condition     = var.orchestration_sending_role_arn == null || can(regex("^arn:aws:iam::", var.orchestration_sending_role_arn))
    error_message = "resource_aws_pinpoint_email_channel, orchestration_sending_role_arn must be a valid IAM role ARN."
  }
}

variable "role_arn" {
  description = "Deprecated: The ARN of an IAM Role used to submit events to Mobile Analytics' event ingestion service."
  type        = string
  default     = null

  validation {
    condition     = var.role_arn == null || can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_pinpoint_email_channel, role_arn must be a valid IAM role ARN."
  }
}