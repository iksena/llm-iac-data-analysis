variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Unique name of the load balancer."
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "data_aws_elb, name must not be null or empty."
  }
}