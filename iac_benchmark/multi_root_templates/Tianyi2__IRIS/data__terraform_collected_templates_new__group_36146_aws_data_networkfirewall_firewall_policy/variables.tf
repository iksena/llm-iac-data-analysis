variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "arn" {
  description = "ARN of the firewall policy"
  type        = string
  default     = null

  validation {
    condition     = var.arn == null || can(regex("^arn:aws:network-firewall:[a-z0-9-]+:[0-9]{12}:firewall-policy/.+", var.arn))
    error_message = "data_aws_networkfirewall_firewall_policy, arn must be a valid ARN format for Network Firewall firewall policy."
  }
}

variable "name" {
  description = "Descriptive name of the firewall policy"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "data_aws_networkfirewall_firewall_policy, name must not be empty when specified."
  }
}

# Validation to ensure at least one of arn or name is provided
locals {
  has_identifier = var.arn != null || var.name != null
}

# Custom validation using check block
check "identifier_validation" {
  assert {
    condition     = local.has_identifier
    error_message = "data_aws_networkfirewall_firewall_policy, either arn or name must be specified."
  }
}