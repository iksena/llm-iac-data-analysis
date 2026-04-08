variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the lifecycle hook."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_autoscaling_lifecycle_hook, name must not be empty."
  }
}

variable "autoscaling_group_name" {
  description = "Name of the Auto Scaling group to which you want to assign the lifecycle hook"
  type        = string

  validation {
    condition     = length(var.autoscaling_group_name) > 0
    error_message = "resource_aws_autoscaling_lifecycle_hook, autoscaling_group_name must not be empty."
  }
}

variable "default_result" {
  description = "Defines the action the Auto Scaling group should take when the lifecycle hook timeout elapses or if an unexpected failure occurs. The value for this parameter can be either CONTINUE or ABANDON. The default value for this parameter is ABANDON."
  type        = string
  default     = "ABANDON"

  validation {
    condition     = contains(["CONTINUE", "ABANDON"], var.default_result)
    error_message = "resource_aws_autoscaling_lifecycle_hook, default_result must be either CONTINUE or ABANDON."
  }
}

variable "heartbeat_timeout" {
  description = "Defines the amount of time, in seconds, that can elapse before the lifecycle hook times out. When the lifecycle hook times out, Auto Scaling performs the action defined in the DefaultResult parameter"
  type        = number
  default     = null

  validation {
    condition     = var.heartbeat_timeout == null || (var.heartbeat_timeout >= 30 && var.heartbeat_timeout <= 7200)
    error_message = "resource_aws_autoscaling_lifecycle_hook, heartbeat_timeout must be between 30 and 7200 seconds."
  }
}

variable "lifecycle_transition" {
  description = "Instance state to which you want to attach the lifecycle hook. For a list of lifecycle hook types, see describe-lifecycle-hook-types"
  type        = string

  validation {
    condition = contains([
      "autoscaling:EC2_INSTANCE_LAUNCHING",
      "autoscaling:EC2_INSTANCE_TERMINATING"
    ], var.lifecycle_transition)
    error_message = "resource_aws_autoscaling_lifecycle_hook, lifecycle_transition must be either autoscaling:EC2_INSTANCE_LAUNCHING or autoscaling:EC2_INSTANCE_TERMINATING."
  }
}

variable "notification_metadata" {
  description = "Contains additional information that you want to include any time Auto Scaling sends a message to the notification target."
  type        = string
  default     = null
}

variable "notification_target_arn" {
  description = "ARN of the notification target that Auto Scaling will use to notify you when an instance is in the transition state for the lifecycle hook. This ARN target can be either an SQS queue, an SNS topic, or a Lambda function."
  type        = string
  default     = null
}

variable "role_arn" {
  description = "ARN of the IAM role that allows the Auto Scaling group to publish to the specified notification target."
  type        = string
  default     = null
}