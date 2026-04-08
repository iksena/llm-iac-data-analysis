variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account_id" {
  description = "The ID of the member AWS account."
  type        = string
  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_securityhub_member, account_id must be a 12-digit AWS account ID."
  }
}

variable "email" {
  description = "The email of the member AWS account."
  type        = string
  default     = null
  validation {
    condition     = var.email == null || can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email))
    error_message = "resource_aws_securityhub_member, email must be a valid email address format."
  }
}

variable "invite" {
  description = "Boolean whether to invite the account to Security Hub as a member. Defaults to false."
  type        = bool
  default     = false
  validation {
    condition     = can(tobool(var.invite))
    error_message = "resource_aws_securityhub_member, invite must be a boolean value."
  }
}