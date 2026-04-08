variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "ARN of the permission set."
  type        = string
  default     = null

  validation {
    condition     = var.arn != null ? can(regex("^arn:aws[a-zA-Z-]*:sso:::permissionSet/[a-zA-Z0-9-/]+$", var.arn)) : true
    error_message = "data_aws_ssoadmin_permission_set, arn must be a valid SSO permission set ARN format."
  }
}

variable "instance_arn" {
  description = "ARN of the SSO Instance associated with the permission set."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:sso:::instance/[a-zA-Z0-9-/]+$", var.instance_arn))
    error_message = "data_aws_ssoadmin_permission_set, instance_arn must be a valid SSO instance ARN format."
  }
}

variable "name" {
  description = "Name of the SSO Permission Set."
  type        = string
  default     = null

  validation {
    condition     = var.name != null ? length(var.name) > 0 && length(var.name) <= 32 : true
    error_message = "data_aws_ssoadmin_permission_set, name must be between 1 and 32 characters long."
  }
}

locals {
  # Validation that either arn or name must be configured
  validate_arn_or_name = var.arn != null || var.name != null ? true : tobool("data_aws_ssoadmin_permission_set: Either arn or name must be configured.")
}