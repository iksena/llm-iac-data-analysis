variable "application_arn" {
  description = "Specifies the ARN of the application with the access scope with the targets to add or update"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso::", var.application_arn))
    error_message = "resource_aws_ssoadmin_application_access_scope, application_arn must be a valid AWS SSO application ARN."
  }
}

variable "scope" {
  description = "Specifies the name of the access scope to be associated with the specified targets"
  type        = string

  validation {
    condition     = length(var.scope) > 0
    error_message = "resource_aws_ssoadmin_application_access_scope, scope cannot be empty."
  }
}

variable "authorized_targets" {
  description = "Specifies an array list of ARNs that represent the authorized targets for this access scope"
  type        = list(string)
  default     = null

  validation {
    condition = var.authorized_targets == null || (
      var.authorized_targets != null && alltrue([
        for target in var.authorized_targets : can(regex("^arn:aws:", target))
      ])
    )
    error_message = "resource_aws_ssoadmin_application_access_scope, authorized_targets must be a list of valid AWS ARNs."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition = var.region == null || (
      var.region != null && can(regex("^[a-z0-9-]+$", var.region))
    )
    error_message = "resource_aws_ssoadmin_application_access_scope, region must be a valid AWS region identifier."
  }
}