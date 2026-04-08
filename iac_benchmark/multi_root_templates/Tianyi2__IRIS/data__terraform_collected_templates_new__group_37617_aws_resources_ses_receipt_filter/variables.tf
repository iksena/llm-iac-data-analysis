variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the filter"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_ses_receipt_filter, name must contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "cidr" {
  description = "The IP address or address range to filter, in CIDR notation"
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr, 0))
    error_message = "resource_aws_ses_receipt_filter, cidr must be a valid CIDR notation (e.g., 10.10.10.10/32 or 192.168.1.0/24)."
  }
}

variable "policy" {
  description = "Block or Allow"
  type        = string

  validation {
    condition     = contains(["Block", "Allow"], var.policy)
    error_message = "resource_aws_ses_receipt_filter, policy must be either 'Block' or 'Allow'."
  }
}