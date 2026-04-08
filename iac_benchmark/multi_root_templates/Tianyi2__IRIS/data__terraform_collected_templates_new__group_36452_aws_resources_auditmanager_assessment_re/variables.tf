variable "name" {
  description = "Name of the assessment report."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_auditmanager_assessment_report, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "assessment_id" {
  description = "Unique identifier of the assessment to create the report from."
  type        = string

  validation {
    condition     = length(var.assessment_id) > 0
    error_message = "resource_aws_auditmanager_assessment_report, assessment_id cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the assessment report."
  type        = string
  default     = null
}