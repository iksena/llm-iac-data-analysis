variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "ARN of the Listener Rule. Either arn or listener_arn must be set."
  type        = string
  default     = null
}

variable "listener_arn" {
  description = "ARN of the associated Listener. Either arn or listener_arn must be set."
  type        = string
  default     = null

  validation {
    condition     = var.arn != null || var.listener_arn != null
    error_message = "data_aws_lb_listener_rule: Either arn or listener_arn must be set."
  }
}

variable "priority" {
  description = "Priority of the Listener Rule within the Listener. Must be set if listener_arn is set, otherwise must not be set."
  type        = number
  default     = null

  validation {
    condition     = (var.listener_arn != null && var.priority != null) || (var.listener_arn == null && var.priority == null)
    error_message = "data_aws_lb_listener_rule, priority: Must be set if listener_arn is set, otherwise must not be set."
  }
}