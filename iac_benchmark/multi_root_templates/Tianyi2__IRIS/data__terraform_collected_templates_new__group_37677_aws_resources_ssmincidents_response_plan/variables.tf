variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the response plan."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ssmincidents_response_plan, name must not be empty."
  }
}

variable "display_name" {
  description = "The long format of the response plan name. This field can contain spaces."
  type        = string
  default     = null
}

variable "chat_channel" {
  description = "The Chatbot chat channel used for collaboration during an incident."
  type        = list(string)
  default     = null
}

variable "engagements" {
  description = "The Amazon Resource Name (ARN) for the contacts and escalation plans that the response plan engages during an incident."
  type        = list(string)
  default     = null

  validation {
    condition = var.engagements == null || alltrue([
      for arn in var.engagements : can(regex("^arn:aws:ssm-contacts:", arn))
    ])
    error_message = "resource_aws_ssmincidents_response_plan, engagements must be valid SSM contacts ARNs starting with 'arn:aws:ssm-contacts:'."
  }
}

variable "tags" {
  description = "The tags applied to the response plan."
  type        = map(string)
  default     = null
}

variable "incident_template" {
  description = "The incident template configuration."
  type = object({
    title         = string
    impact        = string
    dedupe_string = optional(string)
    incident_tags = optional(map(string))
    summary       = optional(string)
    notification_targets = optional(list(object({
      sns_topic_arn = string
    })))
  })

  validation {
    condition     = length(var.incident_template.title) > 0
    error_message = "resource_aws_ssmincidents_response_plan, incident_template.title must not be empty."
  }

  validation {
    condition     = contains(["1", "2", "3", "4", "5"], var.incident_template.impact)
    error_message = "resource_aws_ssmincidents_response_plan, incident_template.impact must be one of: 1 (Severe Impact), 2 (High Impact), 3 (Medium Impact), 4 (Low Impact), 5 (No Impact)."
  }

  validation {
    condition = var.incident_template.notification_targets == null || alltrue([
      for target in var.incident_template.notification_targets : can(regex("^arn:aws:sns:", target.sns_topic_arn))
    ])
    error_message = "resource_aws_ssmincidents_response_plan, incident_template.notification_targets sns_topic_arn must be valid SNS topic ARNs starting with 'arn:aws:sns:'."
  }
}

variable "actions" {
  description = "The actions that the response plan starts at the beginning of an incident."
  type = list(object({
    ssm_automation = optional(object({
      document_name      = string
      role_arn           = string
      document_version   = optional(string)
      target_account     = optional(string)
      dynamic_parameters = optional(map(string))
      parameters = optional(list(object({
        name   = string
        values = list(string)
      })))
    }))
  }))
  default = null

  validation {
    condition = var.actions == null || alltrue([
      for action in var.actions : action.ssm_automation == null || (
        length(action.ssm_automation.document_name) > 0 &&
        can(regex("^arn:aws:iam:", action.ssm_automation.role_arn))
      )
    ])
    error_message = "resource_aws_ssmincidents_response_plan, actions ssm_automation document_name must not be empty and role_arn must be a valid IAM role ARN starting with 'arn:aws:iam:'."
  }

  validation {
    condition = var.actions == null || alltrue([
      for action in var.actions : action.ssm_automation == null || action.ssm_automation.target_account == null || contains([
        "RESPONSE_PLAN_OWNER_ACCOUNT", "IMPACTED_ACCOUNT"
      ], action.ssm_automation.target_account)
    ])
    error_message = "resource_aws_ssmincidents_response_plan, actions ssm_automation target_account must be either 'RESPONSE_PLAN_OWNER_ACCOUNT' or 'IMPACTED_ACCOUNT'."
  }

  validation {
    condition = var.actions == null || alltrue([
      for action in var.actions : action.ssm_automation == null || action.ssm_automation.parameters == null || alltrue([
        for param in action.ssm_automation.parameters : length(param.name) > 0 && length(param.values) > 0
      ])
    ])
    error_message = "resource_aws_ssmincidents_response_plan, actions ssm_automation parameters must have non-empty name and at least one value."
  }
}

variable "integrations" {
  description = "Information about third-party services integrated into the response plan."
  type = list(object({
    pagerduty = optional(object({
      name       = string
      service_id = string
      secret_id  = string
    }))
  }))
  default = null

  validation {
    condition = var.integrations == null || alltrue([
      for integration in var.integrations : integration.pagerduty == null || (
        length(integration.pagerduty.name) > 0 &&
        length(integration.pagerduty.service_id) > 0 &&
        length(integration.pagerduty.secret_id) > 0
      )
    ])
    error_message = "resource_aws_ssmincidents_response_plan, integrations pagerduty name, service_id, and secret_id must not be empty."
  }
}