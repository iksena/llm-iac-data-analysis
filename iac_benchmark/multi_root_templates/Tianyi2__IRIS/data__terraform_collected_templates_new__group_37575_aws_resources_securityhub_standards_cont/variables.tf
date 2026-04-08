variable "association_status" {
  description = "The desired enablement status of the control in the standard"
  type        = string

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.association_status)
    error_message = "resource_aws_securityhub_standards_control_association, association_status must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "security_control_id" {
  description = "The unique identifier for the security control whose enablement status you want to update"
  type        = string
}

variable "standards_arn" {
  description = "The Amazon Resource Name (ARN) of the standard in which you want to update the control's enablement status"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:securityhub:", var.standards_arn))
    error_message = "resource_aws_securityhub_standards_control_association, standards_arn must be a valid Security Hub standards ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "updated_reason" {
  description = "The reason for updating the control's enablement status in the standard"
  type        = string
  default     = null

  validation {
    condition     = var.association_status == "DISABLED" ? var.updated_reason != null : true
    error_message = "resource_aws_securityhub_standards_control_association, updated_reason is required when association_status is 'DISABLED'."
  }
}