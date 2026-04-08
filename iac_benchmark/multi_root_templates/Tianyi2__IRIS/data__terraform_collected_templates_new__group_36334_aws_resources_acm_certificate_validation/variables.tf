variable "certificate_arn" {
  description = "ARN of the certificate that is being validated"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm:", var.certificate_arn))
    error_message = "resource_aws_acm_certificate_validation, certificate_arn must be a valid ACM certificate ARN starting with 'arn:aws:acm:'."
  }
}

variable "validation_record_fqdns" {
  description = "List of FQDNs that implement the validation. Only valid for DNS validation method ACM certificates"
  type        = list(string)
  default     = null

  validation {
    condition = var.validation_record_fqdns == null || (
      var.validation_record_fqdns != null &&
      length(var.validation_record_fqdns) > 0 &&
      alltrue([for fqdn in var.validation_record_fqdns : can(regex("^[a-zA-Z0-9.-]+$", fqdn))])
    )
    error_message = "resource_aws_acm_certificate_validation, validation_record_fqdns must be a list of valid FQDNs containing only alphanumeric characters, dots, and hyphens."
  }
}

variable "timeouts" {
  description = "Configuration block for timeouts"
  type = object({
    create = optional(string, "75m")
  })
  default = {
    create = "75m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_acm_certificate_validation, timeouts.create must be a valid duration string (e.g., '75m', '1h', '90s')."
  }
}

