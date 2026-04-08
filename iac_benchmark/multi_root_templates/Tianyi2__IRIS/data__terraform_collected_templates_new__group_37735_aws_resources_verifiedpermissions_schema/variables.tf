variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "policy_store_id" {
  description = "The ID of the Policy Store."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.policy_store_id))
    error_message = "resource_aws_verifiedpermissions_schema, policy_store_id must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "definition_value" {
  description = "A JSON string representation of the schema."
  type        = string

  validation {
    condition     = can(jsondecode(var.definition_value))
    error_message = "resource_aws_verifiedpermissions_schema, definition_value must be a valid JSON string."
  }
}