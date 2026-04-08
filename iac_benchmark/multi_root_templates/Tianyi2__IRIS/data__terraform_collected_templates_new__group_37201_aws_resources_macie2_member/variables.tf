variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account_id" {
  description = "The AWS account ID for the account."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_macie2_member, account_id must be a 12-digit AWS account ID."
  }
}

variable "email" {
  description = "The email address for the account."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email))
    error_message = "resource_aws_macie2_member, email must be a valid email address."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "status" {
  description = "Specifies the status for the account. To enable Amazon Macie and start all Macie activities for the account, set this value to ENABLED. Valid values are ENABLED or PAUSED."
  type        = string
  default     = null

  validation {
    condition     = var.status == null || contains(["ENABLED", "PAUSED"], var.status)
    error_message = "resource_aws_macie2_member, status must be either 'ENABLED' or 'PAUSED'."
  }
}

variable "invite" {
  description = "Send an invitation to a member"
  type        = bool
  default     = null
}

variable "invitation_message" {
  description = "A custom message to include in the invitation. Amazon Macie adds this message to the standard content that it sends for an invitation."
  type        = string
  default     = null
}

variable "invitation_disable_email_notification" {
  description = "Specifies whether to send an email notification to the root user of each account that the invitation will be sent to. This notification is in addition to an alert that the root user receives in AWS Personal Health Dashboard. To send an email notification to the root user of each account, set this value to true."
  type        = bool
  default     = null
}