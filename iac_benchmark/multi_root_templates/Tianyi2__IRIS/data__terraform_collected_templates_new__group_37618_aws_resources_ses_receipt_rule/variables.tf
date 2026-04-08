variable "name" {
  description = "The name of the rule"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ses_receipt_rule, name must not be empty."
  }
}

variable "rule_set_name" {
  description = "The name of the rule set"
  type        = string

  validation {
    condition     = length(var.rule_set_name) > 0
    error_message = "resource_aws_ses_receipt_rule, rule_set_name must not be empty."
  }
}

variable "after" {
  description = "The name of the rule to place this rule after"
  type        = string
  default     = null
}

variable "enabled" {
  description = "If true, the rule will be enabled"
  type        = bool
  default     = null
}

variable "recipients" {
  description = "A list of email addresses"
  type        = list(string)
  default     = null
}

variable "scan_enabled" {
  description = "If true, incoming emails will be scanned for spam and viruses"
  type        = bool
  default     = null
}

variable "tls_policy" {
  description = "Require or Optional"
  type        = string
  default     = null

  validation {
    condition     = var.tls_policy == null || contains(["Require", "Optional"], var.tls_policy)
    error_message = "resource_aws_ses_receipt_rule, tls_policy must be either 'Require' or 'Optional'."
  }
}

variable "add_header_action" {
  description = "A list of Add Header Action blocks"
  type = list(object({
    header_name  = string
    header_value = string
    position     = number
  }))
  default = []

  validation {
    condition = alltrue([
      for action in var.add_header_action : length(action.header_name) > 0
    ])
    error_message = "resource_aws_ses_receipt_rule, add_header_action header_name must not be empty."
  }

  validation {
    condition = alltrue([
      for action in var.add_header_action : action.position >= 1
    ])
    error_message = "resource_aws_ses_receipt_rule, add_header_action position must be 1 or greater."
  }
}

variable "bounce_action" {
  description = "A list of Bounce Action blocks"
  type = list(object({
    message         = string
    sender          = string
    smtp_reply_code = string
    status_code     = optional(string)
    topic_arn       = optional(string)
    position        = number
  }))
  default = []

  validation {
    condition = alltrue([
      for action in var.bounce_action : length(action.message) > 0
    ])
    error_message = "resource_aws_ses_receipt_rule, bounce_action message must not be empty."
  }

  validation {
    condition = alltrue([
      for action in var.bounce_action : length(action.sender) > 0
    ])
    error_message = "resource_aws_ses_receipt_rule, bounce_action sender must not be empty."
  }

  validation {
    condition = alltrue([
      for action in var.bounce_action : length(action.smtp_reply_code) > 0
    ])
    error_message = "resource_aws_ses_receipt_rule, bounce_action smtp_reply_code must not be empty."
  }

  validation {
    condition = alltrue([
      for action in var.bounce_action : action.position >= 1
    ])
    error_message = "resource_aws_ses_receipt_rule, bounce_action position must be 1 or greater."
  }
}

variable "lambda_action" {
  description = "A list of Lambda Action blocks"
  type = list(object({
    function_arn    = string
    invocation_type = optional(string)
    topic_arn       = optional(string)
    position        = number
  }))
  default = []

  validation {
    condition = alltrue([
      for action in var.lambda_action : length(action.function_arn) > 0
    ])
    error_message = "resource_aws_ses_receipt_rule, lambda_action function_arn must not be empty."
  }

  validation {
    condition = alltrue([
      for action in var.lambda_action : action.invocation_type == null || contains(["Event", "RequestResponse"], action.invocation_type)
    ])
    error_message = "resource_aws_ses_receipt_rule, lambda_action invocation_type must be either 'Event' or 'RequestResponse'."
  }

  validation {
    condition = alltrue([
      for action in var.lambda_action : action.position >= 1
    ])
    error_message = "resource_aws_ses_receipt_rule, lambda_action position must be 1 or greater."
  }
}

variable "s3_action" {
  description = "A list of S3 Action blocks"
  type = list(object({
    bucket_name       = string
    iam_role_arn      = optional(string)
    kms_key_arn       = optional(string)
    object_key_prefix = optional(string)
    topic_arn         = optional(string)
    position          = number
  }))
  default = []

  validation {
    condition = alltrue([
      for action in var.s3_action : length(action.bucket_name) > 0
    ])
    error_message = "resource_aws_ses_receipt_rule, s3_action bucket_name must not be empty."
  }

  validation {
    condition = alltrue([
      for action in var.s3_action : action.position >= 1
    ])
    error_message = "resource_aws_ses_receipt_rule, s3_action position must be 1 or greater."
  }
}

variable "sns_action" {
  description = "A list of SNS Action blocks"
  type = list(object({
    topic_arn = string
    position  = number
    encoding  = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for action in var.sns_action : length(action.topic_arn) > 0
    ])
    error_message = "resource_aws_ses_receipt_rule, sns_action topic_arn must not be empty."
  }

  validation {
    condition = alltrue([
      for action in var.sns_action : action.position >= 1
    ])
    error_message = "resource_aws_ses_receipt_rule, sns_action position must be 1 or greater."
  }
}

variable "stop_action" {
  description = "A list of Stop Action blocks"
  type = list(object({
    scope     = string
    topic_arn = optional(string)
    position  = number
  }))
  default = []

  validation {
    condition = alltrue([
      for action in var.stop_action : action.scope == "RuleSet"
    ])
    error_message = "resource_aws_ses_receipt_rule, stop_action scope must be 'RuleSet'."
  }

  validation {
    condition = alltrue([
      for action in var.stop_action : action.position >= 1
    ])
    error_message = "resource_aws_ses_receipt_rule, stop_action position must be 1 or greater."
  }
}

variable "workmail_action" {
  description = "A list of WorkMail Action blocks"
  type = list(object({
    organization_arn = string
    topic_arn        = optional(string)
    position         = number
  }))
  default = []

  validation {
    condition = alltrue([
      for action in var.workmail_action : length(action.organization_arn) > 0
    ])
    error_message = "resource_aws_ses_receipt_rule, workmail_action organization_arn must not be empty."
  }

  validation {
    condition = alltrue([
      for action in var.workmail_action : action.position >= 1
    ])
    error_message = "resource_aws_ses_receipt_rule, workmail_action position must be 1 or greater."
  }
}