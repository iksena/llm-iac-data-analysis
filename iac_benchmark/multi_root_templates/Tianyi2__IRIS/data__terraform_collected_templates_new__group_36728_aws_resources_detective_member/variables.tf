variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "account_id" {
  description = "AWS account ID for the account"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_detective_member, account_id must be a 12-digit AWS account ID."
  }
}

variable "email_address" {
  description = "Email address for the account"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email_address))
    error_message = "resource_aws_detective_member, email_address must be a valid email address."
  }
}

variable "graph_arn" {
  description = "ARN of the behavior graph to invite the member accounts to contribute their data to"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:detective:[a-z0-9-]+:[0-9]{12}:graph:[a-zA-Z0-9]{32}$", var.graph_arn))
    error_message = "resource_aws_detective_member, graph_arn must be a valid Detective graph ARN."
  }
}

variable "message" {
  description = "A custom message to include in the invitation"
  type        = string
  default     = null
}

variable "disable_email_notification" {
  description = "If set to true, then the root user of the invited account will not receive an email notification"
  type        = bool
  default     = false
}