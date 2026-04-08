variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_arn" {
  description = "The Amazon Resource Name (ARN) of the SSO Instance under which the operation will be executed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::instance/.+$", var.instance_arn))
    error_message = "resource_aws_ssoadmin_permissions_boundary_attachment, instance_arn must be a valid SSO Instance ARN."
  }
}

variable "permission_set_arn" {
  description = "The Amazon Resource Name (ARN) of the Permission Set."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sso:::permissionSet/.+$", var.permission_set_arn))
    error_message = "resource_aws_ssoadmin_permissions_boundary_attachment, permission_set_arn must be a valid Permission Set ARN."
  }
}

variable "permissions_boundary_managed_policy_arn" {
  description = "AWS-managed IAM policy ARN to use as the permissions boundary."
  type        = string
  default     = null

  validation {
    condition     = var.permissions_boundary_managed_policy_arn == null || can(regex("^arn:aws:iam::(aws|\\d{12}):policy/.+$", var.permissions_boundary_managed_policy_arn))
    error_message = "resource_aws_ssoadmin_permissions_boundary_attachment, permissions_boundary_managed_policy_arn must be a valid IAM policy ARN when specified."
  }
}

variable "permissions_boundary_customer_managed_policy_reference" {
  description = "Specifies the name and path of a customer managed policy."
  type = object({
    name = string
    path = optional(string, "/")
  })
  default = null

  validation {
    condition = var.permissions_boundary_customer_managed_policy_reference == null || (
      can(regex("^[A-Za-z0-9+=,.@\\-_]+$", var.permissions_boundary_customer_managed_policy_reference.name)) &&
      can(regex("^/.*/$|^/$", var.permissions_boundary_customer_managed_policy_reference.path))
    )
    error_message = "resource_aws_ssoadmin_permissions_boundary_attachment, permissions_boundary_customer_managed_policy_reference name must be a valid IAM policy name and path must be a valid IAM path."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operation."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_ssoadmin_permissions_boundary_attachment, timeouts_create must be a valid timeout duration (e.g., '10m', '1h', '30s')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operation."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_ssoadmin_permissions_boundary_attachment, timeouts_delete must be a valid timeout duration (e.g., '10m', '1h', '30s')."
  }
}