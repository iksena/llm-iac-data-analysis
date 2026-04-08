variable "email" {
  description = "Email address of the owner to assign to the new member account. This email address must not already be associated with another AWS account."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email))
    error_message = "resource_aws_organizations_account, email must be a valid email address."
  }
}

variable "name" {
  description = "Friendly name for the member account."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 50
    error_message = "resource_aws_organizations_account, name must be between 1 and 50 characters."
  }
}

variable "close_on_deletion" {
  description = "If true, a deletion event will close the account. Otherwise, it will only remove from the organization. This is not supported for GovCloud accounts."
  type        = bool
  default     = null
}

variable "create_govcloud" {
  description = "Whether to also create a GovCloud account. The GovCloud account is tied to the main (commercial) account this resource creates. If true, the GovCloud account ID is available in the govcloud_id attribute."
  type        = bool
  default     = null
}

variable "iam_user_access_to_billing" {
  description = "If set to ALLOW, the new account enables IAM users and roles to access account billing information if they have the required permissions. If set to DENY, then only the root user (and no roles) of the new account can access account billing information."
  type        = string
  default     = null

  validation {
    condition     = var.iam_user_access_to_billing == null || contains(["ALLOW", "DENY"], var.iam_user_access_to_billing)
    error_message = "resource_aws_organizations_account, iam_user_access_to_billing must be either 'ALLOW' or 'DENY'."
  }
}

variable "parent_id" {
  description = "Parent Organizational Unit ID or Root ID for the account. Defaults to the Organization default Root ID."
  type        = string
  default     = null
}

variable "role_name" {
  description = "The name of an IAM role that Organizations automatically preconfigures in the new member account. This role trusts the root account, allowing users in the root account to assume the role, as permitted by the root account administrator."
  type        = string
  default     = null

  validation {
    condition     = var.role_name == null || can(regex("^[a-zA-Z_+=,.@-]+$", var.role_name))
    error_message = "resource_aws_organizations_account, role_name must contain only valid IAM role name characters."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}