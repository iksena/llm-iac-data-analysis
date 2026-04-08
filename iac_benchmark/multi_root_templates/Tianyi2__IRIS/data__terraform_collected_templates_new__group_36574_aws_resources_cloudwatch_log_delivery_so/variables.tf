variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "log_type" {
  description = "The type of log that the source is sending. For Amazon Bedrock, the valid value is APPLICATION_LOGS. For Amazon CodeWhisperer, the valid value is EVENT_LOGS. For IAM Identity Center, the valid value is ERROR_LOGS. For Amazon WorkMail, the valid values are ACCESS_CONTROL_LOGS, AUTHENTICATION_LOGS, WORKMAIL_AVAILABILITY_PROVIDER_LOGS, and WORKMAIL_MAILBOX_ACCESS_LOGS."
  type        = string

  validation {
    condition = contains([
      "APPLICATION_LOGS",
      "EVENT_LOGS",
      "ERROR_LOGS",
      "ACCESS_CONTROL_LOGS",
      "AUTHENTICATION_LOGS",
      "WORKMAIL_AVAILABILITY_PROVIDER_LOGS",
      "WORKMAIL_MAILBOX_ACCESS_LOGS"
    ], var.log_type)
    error_message = "resource_aws_cloudwatch_log_delivery_source, log_type must be one of: APPLICATION_LOGS, EVENT_LOGS, ERROR_LOGS, ACCESS_CONTROL_LOGS, AUTHENTICATION_LOGS, WORKMAIL_AVAILABILITY_PROVIDER_LOGS, WORKMAIL_MAILBOX_ACCESS_LOGS."
  }
}

variable "name" {
  description = "The name for this delivery source."
  type        = string
}

variable "resource_arn" {
  description = "The ARN of the AWS resource that is generating and sending logs."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:[a-zA-Z0-9-]+:[a-zA-Z0-9-]*:[0-9]{12}:.+", var.resource_arn))
    error_message = "resource_aws_cloudwatch_log_delivery_source, resource_arn must be a valid AWS ARN."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}