variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "standards_control_arn" {
  description = "The standards control ARN. See the AWS documentation for how to list existing controls using get-enabled-standards and describe-standards-controls."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:securityhub:", var.standards_control_arn))
    error_message = "resource_aws_securityhub_standards_control, standards_control_arn must be a valid Security Hub standards control ARN starting with 'arn:aws:securityhub:'."
  }
}

variable "control_status" {
  description = "The control status could be ENABLED or DISABLED. You have to specify disabled_reason argument for DISABLED control status."
  type        = string

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.control_status)
    error_message = "resource_aws_securityhub_standards_control, control_status must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "disabled_reason" {
  description = "A description of the reason why you are disabling a security standard control. If you specify this attribute, control_status will be set to DISABLED automatically."
  type        = string
  default     = null

  validation {
    condition     = var.disabled_reason == null || length(var.disabled_reason) > 0
    error_message = "resource_aws_securityhub_standards_control, disabled_reason must not be an empty string when provided."
  }
}