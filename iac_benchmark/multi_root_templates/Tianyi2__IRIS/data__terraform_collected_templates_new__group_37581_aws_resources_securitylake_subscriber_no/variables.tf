variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "subscriber_id" {
  description = "The subscriber ID for the notification subscription."
  type        = string

  validation {
    condition     = length(var.subscriber_id) > 0
    error_message = "resource_aws_securitylake_subscriber_notification, subscriber_id must not be empty."
  }
}

variable "sqs_notification_configuration" {
  description = "The configurations for SQS subscriber notification."
  type        = object({})
  default     = null
}

variable "https_notification_configuration" {
  description = "The configurations for HTTPS subscriber notification."
  type = object({
    endpoint                    = string
    target_role_arn             = string
    authorization_api_key_name  = optional(string)
    authorization_api_key_value = optional(string)
    http_method                 = optional(string)
  })
  default = null

  validation {
    condition = var.https_notification_configuration == null || (
      var.https_notification_configuration.endpoint != null &&
      length(var.https_notification_configuration.endpoint) > 0
    )
    error_message = "resource_aws_securitylake_subscriber_notification, endpoint is required when https_notification_configuration is specified."
  }

  validation {
    condition = var.https_notification_configuration == null || (
      var.https_notification_configuration.target_role_arn != null &&
      length(var.https_notification_configuration.target_role_arn) > 0
    )
    error_message = "resource_aws_securitylake_subscriber_notification, target_role_arn is required when https_notification_configuration is specified."
  }

  validation {
    condition = var.https_notification_configuration == null || (
      var.https_notification_configuration.http_method == null ||
      contains(["POST", "PUT"], var.https_notification_configuration.http_method)
    )
    error_message = "resource_aws_securitylake_subscriber_notification, http_method must be either POST or PUT."
  }
}

variable "create_timeout" {
  description = "Timeout for create operations."
  type        = string
  default     = "60m"
}

variable "update_timeout" {
  description = "Timeout for update operations."
  type        = string
  default     = "180m"
}

variable "delete_timeout" {
  description = "Timeout for delete operations."
  type        = string
  default     = "90m"
}