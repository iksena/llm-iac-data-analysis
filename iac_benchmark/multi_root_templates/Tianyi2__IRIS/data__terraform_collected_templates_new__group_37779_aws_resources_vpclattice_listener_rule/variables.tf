variable "name" {
  description = "The name of the rule. The name must be unique within the listener. The valid characters are a-z, 0-9, and hyphens (-). You can't use a hyphen as the first or last character, or immediately after another hyphen."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.name)) && !can(regex("--", var.name))
    error_message = "resource_aws_vpclattice_listener_rule, name must contain only lowercase letters, numbers, and hyphens, cannot start or end with a hyphen, and cannot have consecutive hyphens."
  }
}

variable "listener_identifier" {
  description = "The ID or Amazon Resource Name (ARN) of the listener."
  type        = string
}

variable "service_identifier" {
  description = "The ID or Amazon Resource Identifier (ARN) of the service."
  type        = string
}

variable "priority" {
  description = "The priority assigned to the rule. Each rule for a specific listener must have a unique priority. The lower the priority number the higher the priority."
  type        = number

  validation {
    condition     = var.priority > 0
    error_message = "resource_aws_vpclattice_listener_rule, priority must be a positive integer."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "action" {
  description = "The action for the listener rule."
  type = object({
    fixed_response = optional(object({
      status_code = optional(number)
    }))
    forward = optional(object({
      target_groups = optional(list(object({
        target_group_identifier = string
        weight                  = optional(number)
      })))
    }))
  })

  validation {
    condition     = (var.action.fixed_response != null && var.action.forward == null) || (var.action.fixed_response == null && var.action.forward != null)
    error_message = "resource_aws_vpclattice_listener_rule, action must have exactly one of fixed_response or forward specified."
  }

  validation {
    condition     = var.action.forward == null || var.action.forward.target_groups == null || length(var.action.forward.target_groups) <= 2
    error_message = "resource_aws_vpclattice_listener_rule, action forward target_groups maximum number is 2."
  }
}

variable "match" {
  description = "The rule match."
  type = object({
    http_match = object({
      method = optional(string)
      header_matches = optional(list(object({
        name           = string
        case_sensitive = optional(bool, false)
        match = optional(object({
          contains = optional(string)
          exact    = optional(string)
          prefix   = optional(string)
        }))
      })))
      path_match = optional(object({
        case_sensitive = optional(bool, false)
        match = optional(object({
          exact  = optional(string)
          prefix = optional(string)
        }))
      }))
    })
  })

  validation {
    condition     = var.match.http_match.header_matches != null || var.match.http_match.method != null || var.match.http_match.path_match != null
    error_message = "resource_aws_vpclattice_listener_rule, match http_match must have at least one of header_matches, method, or path_match specified."
  }

  validation {
    condition = var.match.http_match.header_matches == null || alltrue([
      for hm in var.match.http_match.header_matches : (
        hm.match == null ||
        (hm.match.contains != null && hm.match.exact == null && hm.match.prefix == null) ||
        (hm.match.contains == null && hm.match.exact != null && hm.match.prefix == null) ||
        (hm.match.contains == null && hm.match.exact == null && hm.match.prefix != null)
      )
    ])
    error_message = "resource_aws_vpclattice_listener_rule, match http_match header_matches match must have exactly one of contains, exact, or prefix specified."
  }

  validation {
    condition = var.match.http_match.path_match == null || var.match.http_match.path_match.match == null || (
      (var.match.http_match.path_match.match.exact != null && var.match.http_match.path_match.match.prefix == null) ||
      (var.match.http_match.path_match.match.exact == null && var.match.http_match.path_match.match.prefix != null)
    )
    error_message = "resource_aws_vpclattice_listener_rule, match http_match path_match match must have exactly one of exact or prefix specified."
  }
}