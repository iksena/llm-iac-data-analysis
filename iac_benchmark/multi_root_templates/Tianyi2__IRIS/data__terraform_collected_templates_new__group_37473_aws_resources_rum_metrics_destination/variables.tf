variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "app_monitor_name" {
  description = "The name of the CloudWatch RUM app monitor that will send the metrics."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.app_monitor_name))
    error_message = "resource_aws_rum_metrics_destination, app_monitor_name must contain only alphanumeric characters, dots, dashes, and underscores."
  }
}

variable "destination" {
  description = "Defines the destination to send the metrics to. Valid values are CloudWatch and Evidently."
  type        = string

  validation {
    condition     = contains(["CloudWatch", "Evidently"], var.destination)
    error_message = "resource_aws_rum_metrics_destination, destination must be either 'CloudWatch' or 'Evidently'."
  }
}

variable "destination_arn" {
  description = "Use this parameter only if Destination is Evidently. This parameter specifies the ARN of the Evidently experiment that will receive the extended metrics."
  type        = string
  default     = null

  validation {
    condition     = var.destination_arn == null || can(regex("^arn:aws[a-zA-Z-]*:evidently:[a-z0-9-]+:[0-9]{12}:experiment/[a-zA-Z0-9_.-]+$", var.destination_arn))
    error_message = "resource_aws_rum_metrics_destination, destination_arn must be a valid ARN for an Evidently experiment when provided."
  }
}

variable "iam_role_arn" {
  description = "This parameter is required if Destination is Evidently. If Destination is CloudWatch, do not use this parameter."
  type        = string
  default     = null

  validation {
    condition     = var.iam_role_arn == null || can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/[a-zA-Z0-9_+=,.@-]+$", var.iam_role_arn))
    error_message = "resource_aws_rum_metrics_destination, iam_role_arn must be a valid IAM role ARN when provided."
  }
}