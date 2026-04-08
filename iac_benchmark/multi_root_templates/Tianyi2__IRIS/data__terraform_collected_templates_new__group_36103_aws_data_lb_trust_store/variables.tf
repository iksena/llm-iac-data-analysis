variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "Full ARN of the trust store."
  type        = string
  default     = null

  validation {
    condition     = var.arn == null || can(regex("^arn:aws([a-z-]*)?:elasticloadbalancing:[a-z0-9-]+:[0-9]{12}:truststore/[a-zA-Z0-9-]+$", var.arn))
    error_message = "data_aws_lb_trust_store, arn must be a valid AWS Load Balancer Trust Store ARN."
  }
}

variable "name" {
  description = "Unique name of the trust store."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "data_aws_lb_trust_store, name must not be empty when specified."
  }
}

variable "timeouts_read" {
  description = "How long to wait for the trust store to be read."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_lb_trust_store, timeouts_read must be a valid duration (e.g., '20m', '1h', '30s')."
  }
}