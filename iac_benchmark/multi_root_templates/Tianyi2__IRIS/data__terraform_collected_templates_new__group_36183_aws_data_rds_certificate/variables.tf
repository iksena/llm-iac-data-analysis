variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "id" {
  description = "Certificate identifier. For example, rds-ca-2019."
  type        = string
  default     = null
}

variable "default_for_new_launches" {
  description = "When enabled, returns the default certificate for new RDS instances."
  type        = bool
  default     = null

  validation {
    condition     = var.default_for_new_launches == null || can(tobool(var.default_for_new_launches))
    error_message = "data_aws_rds_certificate, default_for_new_launches must be a boolean value."
  }
}

variable "latest_valid_till" {
  description = "When enabled, returns the certificate with the latest ValidTill."
  type        = bool
  default     = null

  validation {
    condition     = var.latest_valid_till == null || can(tobool(var.latest_valid_till))
    error_message = "data_aws_rds_certificate, latest_valid_till must be a boolean value."
  }
}