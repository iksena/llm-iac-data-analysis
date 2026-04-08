variable "control_panel_arn" {
  description = "ARN of the control panel in which this safety rule will reside"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:route53-recovery-control::", var.control_panel_arn))
    error_message = "resource_aws_route53recoverycontrolconfig_safety_rule, control_panel_arn must be a valid Route 53 Recovery Control ARN."
  }
}

variable "name" {
  description = "Name describing the safety rule"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_route53recoverycontrolconfig_safety_rule, name cannot be empty."
  }
}

variable "wait_period_ms" {
  description = "Evaluation period, in milliseconds (ms), during which any request against the target routing controls will fail"
  type        = number

  validation {
    condition     = var.wait_period_ms > 0
    error_message = "resource_aws_route53recoverycontrolconfig_safety_rule, wait_period_ms must be greater than 0."
  }
}

variable "rule_config" {
  description = "Configuration block for safety rule criteria"
  type = object({
    inverted  = bool
    threshold = number
    type      = string
  })

  validation {
    condition     = contains(["ATLEAST", "AND", "OR"], var.rule_config.type)
    error_message = "resource_aws_route53recoverycontrolconfig_safety_rule, rule_config.type must be one of: ATLEAST, AND, OR."
  }

  validation {
    condition     = var.rule_config.threshold >= 0
    error_message = "resource_aws_route53recoverycontrolconfig_safety_rule, rule_config.threshold must be greater than or equal to 0."
  }
}

variable "asserted_controls" {
  description = "Routing controls that are part of transactions that are evaluated to determine if a request to change a routing control state is allowed"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for control in var.asserted_controls : can(regex("^arn:aws:", control))
    ])
    error_message = "resource_aws_route53recoverycontrolconfig_safety_rule, asserted_controls must be valid ARNs."
  }
}

variable "gating_controls" {
  description = "Gating controls for the new gating rule. That is, routing controls that are evaluated by the rule configuration that you specify"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for control in var.gating_controls : can(regex("^arn:aws:", control))
    ])
    error_message = "resource_aws_route53recoverycontrolconfig_safety_rule, gating_controls must be valid ARNs."
  }
}

variable "target_controls" {
  description = "Routing controls that can only be set or unset if the specified rule_config evaluates to true for the specified gating_controls"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for control in var.target_controls : can(regex("^arn:aws:", control))
    ])
    error_message = "resource_aws_route53recoverycontrolconfig_safety_rule, target_controls must be valid ARNs."
  }
}