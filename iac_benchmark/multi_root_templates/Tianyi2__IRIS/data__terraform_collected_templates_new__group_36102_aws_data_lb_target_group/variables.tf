variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "Full ARN of the target group."
  type        = string
  default     = null

  validation {
    condition     = var.arn == null || can(regex("^arn:aws:elasticloadbalancing:", var.arn))
    error_message = "data_aws_lb_target_group, arn must be a valid ELB target group ARN starting with 'arn:aws:elasticloadbalancing:'."
  }
}

variable "name" {
  description = "Unique name of the target group."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || (length(var.name) >= 1 && length(var.name) <= 32)
    error_message = "data_aws_lb_target_group, name must be between 1 and 32 characters in length."
  }

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "data_aws_lb_target_group, name must contain only alphanumeric characters and hyphens."
  }
}

variable "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the desired target group."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : length(k) >= 1 && length(k) <= 128
    ])
    error_message = "data_aws_lb_target_group, tags keys must be between 1 and 128 characters in length."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : length(v) <= 256
    ])
    error_message = "data_aws_lb_target_group, tags values must be no more than 256 characters in length."
  }
}

variable "timeouts_read" {
  description = "Timeout for reading the target group data."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_lb_target_group, timeouts_read must be a valid duration (e.g., '20m', '1h', '30s')."
  }
}