variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_arn" {
  description = "ARN of the instance of IAM Identity Center."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:sso:::instance/[a-zA-Z0-9-]+$", var.instance_arn))
    error_message = "data_aws_ssoadmin_principal_application_assignments, instance_arn must be a valid IAM Identity Center instance ARN."
  }
}

variable "principal_id" {
  description = "An identifier for an object in IAM Identity Center, such as a user or group."
  type        = string

  validation {
    condition     = length(var.principal_id) > 0
    error_message = "data_aws_ssoadmin_principal_application_assignments, principal_id cannot be empty."
  }
}

variable "principal_type" {
  description = "Entity type for which the assignment will be created. Valid values are USER or GROUP."
  type        = string

  validation {
    condition     = contains(["USER", "GROUP"], var.principal_type)
    error_message = "data_aws_ssoadmin_principal_application_assignments, principal_type must be either USER or GROUP."
  }
}