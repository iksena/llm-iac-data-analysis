variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the resource policy."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:network-firewall:", var.resource_arn))
    error_message = "data_aws_networkfirewall_resource_policy, resource_arn must be a valid Network Firewall ARN starting with 'arn:aws:network-firewall:'."
  }
}