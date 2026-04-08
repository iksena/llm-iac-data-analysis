variable "name" {
  description = "The friendly name for the SNS platform application"
  type        = string
}

variable "platform" {
  description = "The platform that the app is registered with"
  type        = string
  validation {
    condition = contains([
      "APNS", "APNS_SANDBOX", "APNS_VOIP", "APNS_VOIP_SANDBOX",
      "GCM", "FCM", "ADM", "BAIDU", "MPNS", "WNS"
    ], var.platform)
    error_message = "resource_aws_sns_platform_application, platform must be one of: APNS, APNS_SANDBOX, APNS_VOIP, APNS_VOIP_SANDBOX, GCM, FCM, ADM, BAIDU, MPNS, WNS."
  }
}

variable "platform_credential" {
  description = "Application Platform credential"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "event_delivery_failure_topic_arn" {
  description = "The ARN of the SNS Topic triggered when a delivery to any of the platform endpoints associated with your platform application encounters a permanent failure"
  type        = string
  default     = null
  validation {
    condition     = var.event_delivery_failure_topic_arn == null || can(regex("^arn:aws:sns:[a-z0-9-]+:[0-9]{12}:[a-zA-Z0-9_-]+$", var.event_delivery_failure_topic_arn))
    error_message = "resource_aws_sns_platform_application, event_delivery_failure_topic_arn must be a valid SNS topic ARN."
  }
}

variable "event_endpoint_created_topic_arn" {
  description = "The ARN of the SNS Topic triggered when a new platform endpoint is added to your platform application"
  type        = string
  default     = null
  validation {
    condition     = var.event_endpoint_created_topic_arn == null || can(regex("^arn:aws:sns:[a-z0-9-]+:[0-9]{12}:[a-zA-Z0-9_-]+$", var.event_endpoint_created_topic_arn))
    error_message = "resource_aws_sns_platform_application, event_endpoint_created_topic_arn must be a valid SNS topic ARN."
  }
}

variable "event_endpoint_deleted_topic_arn" {
  description = "The ARN of the SNS Topic triggered when an existing platform endpoint is deleted from your platform application"
  type        = string
  default     = null
  validation {
    condition     = var.event_endpoint_deleted_topic_arn == null || can(regex("^arn:aws:sns:[a-z0-9-]+:[0-9]{12}:[a-zA-Z0-9_-]+$", var.event_endpoint_deleted_topic_arn))
    error_message = "resource_aws_sns_platform_application, event_endpoint_deleted_topic_arn must be a valid SNS topic ARN."
  }
}

variable "event_endpoint_updated_topic_arn" {
  description = "The ARN of the SNS Topic triggered when an existing platform endpoint is changed from your platform application"
  type        = string
  default     = null
  validation {
    condition     = var.event_endpoint_updated_topic_arn == null || can(regex("^arn:aws:sns:[a-z0-9-]+:[0-9]{12}:[a-zA-Z0-9_-]+$", var.event_endpoint_updated_topic_arn))
    error_message = "resource_aws_sns_platform_application, event_endpoint_updated_topic_arn must be a valid SNS topic ARN."
  }
}

variable "failure_feedback_role_arn" {
  description = "The IAM role ARN permitted to receive failure feedback for this application and give SNS write access to use CloudWatch logs on your behalf"
  type        = string
  default     = null
  validation {
    condition     = var.failure_feedback_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.failure_feedback_role_arn))
    error_message = "resource_aws_sns_platform_application, failure_feedback_role_arn must be a valid IAM role ARN."
  }
}

variable "platform_principal" {
  description = "Application Platform principal"
  type        = string
  default     = null
  sensitive   = true
}

variable "success_feedback_role_arn" {
  description = "The IAM role ARN permitted to receive success feedback for this application and give SNS write access to use CloudWatch logs on your behalf"
  type        = string
  default     = null
  validation {
    condition     = var.success_feedback_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.success_feedback_role_arn))
    error_message = "resource_aws_sns_platform_application, success_feedback_role_arn must be a valid IAM role ARN."
  }
}

variable "success_feedback_sample_rate" {
  description = "The sample rate percentage (0-100) of successfully delivered messages"
  type        = number
  default     = null
  validation {
    condition     = var.success_feedback_sample_rate == null || (var.success_feedback_sample_rate >= 0 && var.success_feedback_sample_rate <= 100)
    error_message = "resource_aws_sns_platform_application, success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "apple_platform_team_id" {
  description = "The identifier that's assigned to your Apple developer account team. Must be 10 alphanumeric characters"
  type        = string
  default     = null
  validation {
    condition     = var.apple_platform_team_id == null || can(regex("^[a-zA-Z0-9]{10}$", var.apple_platform_team_id))
    error_message = "resource_aws_sns_platform_application, apple_platform_team_id must be exactly 10 alphanumeric characters."
  }
}

variable "apple_platform_bundle_id" {
  description = "The bundle identifier that's assigned to your iOS app. May only include alphanumeric characters, hyphens (-), and periods (.)"
  type        = string
  default     = null
  validation {
    condition     = var.apple_platform_bundle_id == null || can(regex("^[a-zA-Z0-9.-]+$", var.apple_platform_bundle_id))
    error_message = "resource_aws_sns_platform_application, apple_platform_bundle_id may only include alphanumeric characters, hyphens (-), and periods (.)."
  }
}