variable "assessment_id" {
  description = "Identifier for the assessment."
  type        = string

  validation {
    condition     = length(var.assessment_id) > 0
    error_message = "resource_aws_auditmanager_assessment_delegation, assessment_id cannot be empty."
  }
}

variable "control_set_id" {
  description = "Assessment control set name. This value is the control set name used during assessment creation (not the AWS-generated ID). The _id suffix on this attribute has been preserved to be consistent with the underlying AWS API."
  type        = string

  validation {
    condition     = length(var.control_set_id) > 0
    error_message = "resource_aws_auditmanager_assessment_delegation, control_set_id cannot be empty."
  }
}

variable "role_arn" {
  description = "Amazon Resource Name (ARN) of the IAM role."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_auditmanager_assessment_delegation, role_arn must be a valid IAM role ARN."
  }
}

variable "role_type" {
  description = "Type of customer persona. For assessment delegation, type must always be RESOURCE_OWNER."
  type        = string

  validation {
    condition     = var.role_type == "RESOURCE_OWNER"
    error_message = "resource_aws_auditmanager_assessment_delegation, role_type must be 'RESOURCE_OWNER'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "comment" {
  description = "Comment describing the delegation request."
  type        = string
  default     = null
}