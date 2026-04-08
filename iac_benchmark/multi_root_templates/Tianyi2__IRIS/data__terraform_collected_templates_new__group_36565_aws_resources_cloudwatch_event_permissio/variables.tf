variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "principal" {
  description = "The 12-digit AWS account ID that you are permitting to put events to your default event bus. Specify '*' to permit any account to put events to your default event bus, optionally limited by condition."
  type        = string

  validation {
    condition     = can(regex("^\\*$|^[0-9]{12}$", var.principal))
    error_message = "resource_aws_cloudwatch_event_permission, principal must be either '*' or a 12-digit AWS account ID."
  }
}

variable "statement_id" {
  description = "An identifier string for the external account that you are granting permissions to."
  type        = string
}

variable "action" {
  description = "The action that you are enabling the other account to perform. Defaults to 'events:PutEvents'."
  type        = string
  default     = "events:PutEvents"
}

variable "event_bus_name" {
  description = "The name of the event bus to set the permissions on. If you omit this, the permissions are set on the 'default' event bus."
  type        = string
  default     = null
}

variable "condition" {
  description = "Configuration block to limit the event bus permissions you are granting to only accounts that fulfill the condition."
  type = object({
    key   = string
    type  = string
    value = string
  })
  default = null

  validation {
    condition     = var.condition == null || contains(["aws:PrincipalOrgID"], var.condition.key)
    error_message = "resource_aws_cloudwatch_event_permission, condition key must be 'aws:PrincipalOrgID'."
  }

  validation {
    condition     = var.condition == null || contains(["StringEquals"], var.condition.type)
    error_message = "resource_aws_cloudwatch_event_permission, condition type must be 'StringEquals'."
  }
}