variable "hosted_zone_id" {
  description = "Identifier of the Route 53 Hosted Zone"
  type        = string

  validation {
    condition     = can(regex("^[A-Z0-9]{10,32}$", var.hosted_zone_id))
    error_message = "resource_aws_route53_hosted_zone_dnssec, hosted_zone_id must be a valid Route 53 hosted zone ID (10-32 alphanumeric characters)."
  }
}

variable "signing_status" {
  description = "Hosted Zone signing status. Valid values: SIGNING, NOT_SIGNING"
  type        = string
  default     = "SIGNING"

  validation {
    condition     = contains(["SIGNING", "NOT_SIGNING"], var.signing_status)
    error_message = "resource_aws_route53_hosted_zone_dnssec, signing_status must be either 'SIGNING' or 'NOT_SIGNING'."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the DNSSEC configuration"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_route53_hosted_zone_dnssec, timeouts_create must be a valid timeout format (e.g., '30m', '1h', '300s')."
  }
}

variable "timeouts_update" {
  description = "Timeout for updating the DNSSEC configuration"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_route53_hosted_zone_dnssec, timeouts_update must be a valid timeout format (e.g., '30m', '1h', '300s')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the DNSSEC configuration"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_route53_hosted_zone_dnssec, timeouts_delete must be a valid timeout format (e.g., '30m', '1h', '300s')."
  }
}