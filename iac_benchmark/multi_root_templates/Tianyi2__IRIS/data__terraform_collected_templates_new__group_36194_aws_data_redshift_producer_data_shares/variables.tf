variable "producer_arn" {
  description = "Amazon Resource Name (ARN) of the producer namespace that returns in the list of datashares"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:redshift:", var.producer_arn))
    error_message = "data_redshift_producer_data_shares, producer_arn must be a valid ARN starting with 'arn:aws:redshift:'"
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_redshift_producer_data_shares, region must be a valid AWS region format (lowercase letters, numbers, and hyphens only)"
  }
}

variable "status" {
  description = "Status of a datashare in the producer. Valid values are ACTIVE, AUTHORIZED, PENDING_AUTHORIZATION, DEAUTHORIZED, and REJECTED"
  type        = string
  default     = null

  validation {
    condition = var.status == null || contains([
      "ACTIVE",
      "AUTHORIZED",
      "PENDING_AUTHORIZATION",
      "DEAUTHORIZED",
      "REJECTED"
    ], var.status)
    error_message = "data_redshift_producer_data_shares, status must be one of: ACTIVE, AUTHORIZED, PENDING_AUTHORIZATION, DEAUTHORIZED, REJECTED"
  }
}