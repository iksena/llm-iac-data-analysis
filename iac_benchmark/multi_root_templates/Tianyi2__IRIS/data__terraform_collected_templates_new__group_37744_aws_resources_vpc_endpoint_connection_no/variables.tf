variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_endpoint_service_id" {
  description = "The ID of the VPC Endpoint Service to receive notifications for."
  type        = string
  default     = null

  validation {
    condition     = var.vpc_endpoint_service_id != null || var.vpc_endpoint_id != null
    error_message = "resource_aws_vpc_endpoint_connection_notification, vpc_endpoint_service_id: One of vpc_endpoint_service_id or vpc_endpoint_id must be specified."
  }
}

variable "vpc_endpoint_id" {
  description = "The ID of the VPC Endpoint to receive notifications for."
  type        = string
  default     = null
}

variable "connection_notification_arn" {
  description = "The ARN of the SNS topic for the notifications."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sns:", var.connection_notification_arn))
    error_message = "resource_aws_vpc_endpoint_connection_notification, connection_notification_arn: Must be a valid SNS topic ARN."
  }
}

variable "connection_events" {
  description = "One or more endpoint events for which to receive notifications."
  type        = list(string)

  validation {
    condition     = length(var.connection_events) > 0
    error_message = "resource_aws_vpc_endpoint_connection_notification, connection_events: At least one connection event must be specified."
  }

  validation {
    condition = alltrue([
      for event in var.connection_events : contains(["Accept", "Connect", "Delete", "Reject"], event)
    ])
    error_message = "resource_aws_vpc_endpoint_connection_notification, connection_events: Valid events are Accept, Connect, Delete, and Reject."
  }
}