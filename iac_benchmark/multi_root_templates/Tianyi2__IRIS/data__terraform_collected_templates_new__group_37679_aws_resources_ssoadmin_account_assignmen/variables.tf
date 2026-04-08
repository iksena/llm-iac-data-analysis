variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_arn" {
  description = "The Amazon Resource Name (ARN) of the SSO Instance."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::instance/ssoins-[a-f0-9]{16}$", var.instance_arn))
    error_message = "resource_aws_ssoadmin_account_assignment, instance_arn must be a valid SSO instance ARN in the format 'arn:aws:sso:::instance/ssoins-{16 hex characters}'."
  }
}

variable "permission_set_arn" {
  description = "The Amazon Resource Name (ARN) of the Permission Set that the admin wants to grant the principal access to."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::permissionSet/ssoins-[a-f0-9]{16}/ps-[a-f0-9]{16}$", var.permission_set_arn))
    error_message = "resource_aws_ssoadmin_account_assignment, permission_set_arn must be a valid SSO permission set ARN in the format 'arn:aws:sso:::permissionSet/ssoins-{16 hex}/ps-{16 hex}'."
  }
}

variable "principal_id" {
  description = "An identifier for an object in SSO, such as a user or group. PrincipalIds are GUIDs."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.principal_id))
    error_message = "resource_aws_ssoadmin_account_assignment, principal_id must be a valid GUID format (e.g., f81d4fae-7dec-11d0-a765-00a0c91e6bf6)."
  }
}

variable "principal_type" {
  description = "The entity type for which the assignment will be created."
  type        = string

  validation {
    condition     = contains(["USER", "GROUP"], var.principal_type)
    error_message = "resource_aws_ssoadmin_account_assignment, principal_type must be one of: USER, GROUP."
  }
}

variable "target_id" {
  description = "An AWS account identifier, typically a 10-12 digit string."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{10,12}$", var.target_id))
    error_message = "resource_aws_ssoadmin_account_assignment, target_id must be a 10-12 digit AWS account identifier."
  }
}

variable "target_type" {
  description = "The entity type for which the assignment will be created."
  type        = string
  default     = "AWS_ACCOUNT"

  validation {
    condition     = contains(["AWS_ACCOUNT"], var.target_type)
    error_message = "resource_aws_ssoadmin_account_assignment, target_type must be: AWS_ACCOUNT."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the account assignment."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_ssoadmin_account_assignment, timeouts_create must be a valid duration string (e.g., 5m, 10s, 1h)."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the account assignment."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_ssoadmin_account_assignment, timeouts_delete must be a valid duration string (e.g., 5m, 10s, 1h)."
  }
}