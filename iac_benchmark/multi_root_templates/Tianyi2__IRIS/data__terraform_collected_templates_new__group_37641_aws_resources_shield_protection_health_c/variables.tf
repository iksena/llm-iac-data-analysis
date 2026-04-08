variable "health_check_arn" {
  description = "The ARN (Amazon Resource Name) of the Route53 Health Check resource which will be associated to the protected resource."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:route53:::healthcheck/[a-f0-9-]+$", var.health_check_arn))
    error_message = "resource_aws_shield_protection_health_check_association, health_check_arn must be a valid Route53 Health Check ARN."
  }
}

variable "shield_protection_id" {
  description = "The ID of the protected resource."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9-]{36}$", var.shield_protection_id))
    error_message = "resource_aws_shield_protection_health_check_association, shield_protection_id must be a valid UUID format."
  }
}