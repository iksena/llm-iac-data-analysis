variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "Full ARN of the load balancer."
  type        = string
  default     = null

  validation {
    condition     = var.arn == null || can(regex("^arn:aws:elasticloadbalancing:", var.arn))
    error_message = "data_aws_lb, arn must be a valid ELB ARN starting with 'arn:aws:elasticloadbalancing:'."
  }
}

variable "name" {
  description = "Unique name of the load balancer."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || (length(var.name) >= 1 && length(var.name) <= 32)
    error_message = "data_aws_lb, name must be between 1 and 32 characters in length."
  }
}

variable "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the desired load balancer."
  type        = map(string)
  default     = null

  validation {
    condition     = var.tags == null || length(var.tags) <= 50
    error_message = "data_aws_lb, tags cannot exceed 50 key-value pairs."
  }
}