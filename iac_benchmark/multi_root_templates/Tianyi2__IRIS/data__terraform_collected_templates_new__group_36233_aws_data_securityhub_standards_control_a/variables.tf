variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_securityhub_standards_control_associations, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "security_control_id" {
  description = "The identifier of the control (identified with SecurityControlId, SecurityControlArn, or a mix of both parameters)."
  type        = string

  validation {
    condition     = var.security_control_id != null && var.security_control_id != ""
    error_message = "data_aws_securityhub_standards_control_associations, security_control_id cannot be null or empty."
  }
}