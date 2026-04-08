variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "policy_store_id" {
  description = "The Policy Store ID of the policy store."
  type        = string

  validation {
    condition     = length(var.policy_store_id) > 0
    error_message = "resource_aws_verifiedpermissions_policy, policy_store_id must be a non-empty string."
  }
}

variable "definition_static" {
  description = "The static policy statement."
  type = object({
    description = optional(string)
    statement   = string
  })
  default = null

  validation {
    condition = var.definition_static == null || (
      var.definition_static.statement != null &&
      length(var.definition_static.statement) > 0
    )
    error_message = "resource_aws_verifiedpermissions_policy, definition_static.statement must be a non-empty string when definition_static is provided."
  }
}

variable "definition_template_linked" {
  description = "The template linked policy."
  type = object({
    policy_template_id = string
    principal = optional(object({
      entity_id   = string
      entity_type = string
    }))
    resource = optional(object({
      entity_id   = string
      entity_type = string
    }))
  })
  default = null

  validation {
    condition = var.definition_template_linked == null || (
      var.definition_template_linked.policy_template_id != null &&
      length(var.definition_template_linked.policy_template_id) > 0
    )
    error_message = "resource_aws_verifiedpermissions_policy, definition_template_linked.policy_template_id must be a non-empty string when definition_template_linked is provided."
  }

  validation {
    condition = var.definition_template_linked == null || var.definition_template_linked.principal == null || (
      var.definition_template_linked.principal.entity_id != null &&
      length(var.definition_template_linked.principal.entity_id) > 0 &&
      var.definition_template_linked.principal.entity_type != null &&
      length(var.definition_template_linked.principal.entity_type) > 0
    )
    error_message = "resource_aws_verifiedpermissions_policy, definition_template_linked.principal.entity_id and entity_type must be non-empty strings when principal is provided."
  }

  validation {
    condition = var.definition_template_linked == null || var.definition_template_linked.resource == null || (
      var.definition_template_linked.resource.entity_id != null &&
      length(var.definition_template_linked.resource.entity_id) > 0 &&
      var.definition_template_linked.resource.entity_type != null &&
      length(var.definition_template_linked.resource.entity_type) > 0
    )
    error_message = "resource_aws_verifiedpermissions_policy, definition_template_linked.resource.entity_id and entity_type must be non-empty strings when resource is provided."
  }

  validation {
    condition     = var.definition_static != null || var.definition_template_linked != null
    error_message = "resource_aws_verifiedpermissions_policy, definition must have either static or template_linked configuration."
  }
}