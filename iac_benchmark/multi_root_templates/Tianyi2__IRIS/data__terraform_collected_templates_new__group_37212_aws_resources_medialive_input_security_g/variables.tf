variable "whitelist_rules" {
  description = "Whitelist rules. Each rule must contain a CIDR."
  type = list(object({
    cidr = string
  }))

  validation {
    condition     = length(var.whitelist_rules) > 0
    error_message = "resource_aws_medialive_input_security_group, whitelist_rules: At least one whitelist rule must be specified."
  }

  validation {
    condition = alltrue([
      for rule in var.whitelist_rules : can(cidrhost(rule.cidr, 0))
    ])
    error_message = "resource_aws_medialive_input_security_group, whitelist_rules: All CIDR blocks must be valid IPv4 CIDR notation."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the InputSecurityGroup."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = {}

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_medialive_input_security_group, timeouts: Timeout values must be valid duration strings (e.g., '5m', '30s', '1h')."
  }
}