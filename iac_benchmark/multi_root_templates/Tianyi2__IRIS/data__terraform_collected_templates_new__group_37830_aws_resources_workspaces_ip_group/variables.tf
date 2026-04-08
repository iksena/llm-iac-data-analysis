variable "name" {
  description = "The name of the IP group"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_workspaces_ip_group, name cannot be empty."
  }
}

variable "description" {
  description = "The description of the IP group"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "rules" {
  description = "One or more pairs specifying the IP group rule (in CIDR format) from which web requests originate"
  type = list(object({
    source      = string
    description = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.rules : can(cidrhost(rule.source, 0))
    ])
    error_message = "resource_aws_workspaces_ip_group, rules source must be in valid CIDR format."
  }
}

variable "tags" {
  description = "A map of tags assigned to the WorkSpaces directory"
  type        = map(string)
  default     = {}
}