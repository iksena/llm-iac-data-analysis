variable "arn" {
  description = "ARN of the listener. Required if load_balancer_arn and port is not set."
  type        = string
  default     = null
}

variable "load_balancer_arn" {
  description = "ARN of the load balancer. Required if arn is not set."
  type        = string
  default     = null
}

variable "port" {
  description = "Port of the listener. Required if arn is not set."
  type        = number
  default     = null

  validation {
    condition     = var.port == null || (var.port >= 1 && var.port <= 65535)
    error_message = "data_aws_lb_listener, port must be a valid port number between 1 and 65535."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operations"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_lb_listener, timeouts_read must be a valid timeout string (e.g., '20m', '10s', '1h')."
  }
}