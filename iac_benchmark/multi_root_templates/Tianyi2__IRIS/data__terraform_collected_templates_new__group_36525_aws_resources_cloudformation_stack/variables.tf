variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Stack name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][-a-zA-Z0-9]*$", var.name))
    error_message = "resource_aws_cloudformation_stack, name must start with a letter and can only contain letters, numbers, and hyphens."
  }
}

variable "template_body" {
  description = "Structure containing the template body (max size: 51,200 bytes)."
  type        = string
  default     = null

  validation {
    condition     = var.template_body == null || length(var.template_body) <= 51200
    error_message = "resource_aws_cloudformation_stack, template_body must not exceed 51,200 bytes."
  }
}

variable "template_url" {
  description = "Location of a file containing the template body (max size: 460,800 bytes)."
  type        = string
  default     = null

  validation {
    condition     = var.template_url == null || can(regex("^https?://", var.template_url))
    error_message = "resource_aws_cloudformation_stack, template_url must be a valid HTTP or HTTPS URL."
  }
}

variable "capabilities" {
  description = "A list of capabilities. Valid values: CAPABILITY_IAM, CAPABILITY_NAMED_IAM, or CAPABILITY_AUTO_EXPAND"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for capability in var.capabilities : contains(["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"], capability)
    ])
    error_message = "resource_aws_cloudformation_stack, capabilities must contain only valid values: CAPABILITY_IAM, CAPABILITY_NAMED_IAM, or CAPABILITY_AUTO_EXPAND."
  }
}

variable "disable_rollback" {
  description = "Set to true to disable rollback of the stack if stack creation failed. Conflicts with on_failure."
  type        = bool
  default     = null
}

variable "notification_arns" {
  description = "A list of SNS topic ARNs to publish stack related events."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for arn in var.notification_arns : can(regex("^arn:aws:sns:", arn))
    ])
    error_message = "resource_aws_cloudformation_stack, notification_arns must contain valid SNS topic ARNs."
  }
}

variable "on_failure" {
  description = "Action to be taken if stack creation fails. This must be one of: DO_NOTHING, ROLLBACK, or DELETE. Conflicts with disable_rollback."
  type        = string
  default     = null

  validation {
    condition     = var.on_failure == null || contains(["DO_NOTHING", "ROLLBACK", "DELETE"], var.on_failure)
    error_message = "resource_aws_cloudformation_stack, on_failure must be one of: DO_NOTHING, ROLLBACK, or DELETE."
  }
}

variable "parameters" {
  description = "A map of Parameter structures that specify input parameters for the stack."
  type        = map(string)
  default     = {}
}

variable "policy_body" {
  description = "Structure containing the stack policy body. Conflicts with policy_url."
  type        = string
  default     = null
}

variable "policy_url" {
  description = "Location of a file containing the stack policy. Conflicts with policy_body."
  type        = string
  default     = null

  validation {
    condition     = var.policy_url == null || can(regex("^https?://", var.policy_url))
    error_message = "resource_aws_cloudformation_stack, policy_url must be a valid HTTP or HTTPS URL."
  }
}

variable "tags" {
  description = "Map of resource tags to associate with this stack."
  type        = map(string)
  default     = {}
}

variable "iam_role_arn" {
  description = "The ARN of an IAM role that AWS CloudFormation assumes to create the stack."
  type        = string
  default     = null

  validation {
    condition     = var.iam_role_arn == null || can(regex("^arn:aws:iam::", var.iam_role_arn))
    error_message = "resource_aws_cloudformation_stack, iam_role_arn must be a valid IAM role ARN."
  }
}

variable "timeout_in_minutes" {
  description = "The amount of time that can pass before the stack status becomes CREATE_FAILED."
  type        = number
  default     = null

  validation {
    condition     = var.timeout_in_minutes == null || (var.timeout_in_minutes > 0 && var.timeout_in_minutes <= 43200)
    error_message = "resource_aws_cloudformation_stack, timeout_in_minutes must be between 1 and 43200 minutes (30 days)."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_cloudformation_stack, timeouts_create must be a valid duration (e.g., 30m, 1h, 120s)."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_cloudformation_stack, timeouts_update must be a valid duration (e.g., 30m, 1h, 120s)."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_cloudformation_stack, timeouts_delete must be a valid duration (e.g., 30m, 1h, 120s)."
  }
}