variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_networkfirewall_resource_policy, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "policy" {
  type        = string
  description = "JSON formatted policy document that controls access to the Network Firewall resource. The policy must be provided without whitespaces."

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_networkfirewall_resource_policy, policy must be a valid JSON string."
  }
}

variable "resource_arn" {
  type        = string
  description = "The Amazon Resource Name (ARN) of the rule group or firewall policy."

  validation {
    condition     = can(regex("^arn:aws:network-firewall:[a-z0-9-]+:[0-9]+:(stateful-rulegroup|stateless-rulegroup|firewall-policy)/.+$", var.resource_arn))
    error_message = "resource_aws_networkfirewall_resource_policy, resource_arn must be a valid Network Firewall rule group or firewall policy ARN."
  }
}