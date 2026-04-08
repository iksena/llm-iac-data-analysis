variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "listener_arn" {
  description = "The ARN of the listener to which to attach the certificate."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:elasticloadbalancing:", var.listener_arn))
    error_message = "resource_aws_lb_listener_certificate, listener_arn must be a valid ELB listener ARN."
  }
}

variable "certificate_arn" {
  description = "The ARN of the certificate to attach to the listener."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:(acm|iam):", var.certificate_arn))
    error_message = "resource_aws_lb_listener_certificate, certificate_arn must be a valid ACM or IAM certificate ARN."
  }
}