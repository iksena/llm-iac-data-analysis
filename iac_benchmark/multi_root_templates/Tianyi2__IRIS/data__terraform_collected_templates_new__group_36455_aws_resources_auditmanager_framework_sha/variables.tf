variable "destination_account" {
  description = "Amazon Web Services account of the recipient."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.destination_account))
    error_message = "resource_aws_auditmanager_framework_share, destination_account must be a 12-digit AWS account ID."
  }
}

variable "destination_region" {
  description = "Amazon Web Services region of the recipient."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.destination_region))
    error_message = "resource_aws_auditmanager_framework_share, destination_region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "framework_id" {
  description = "Unique identifier for the shared custom framework."
  type        = string

  validation {
    condition     = length(var.framework_id) > 0
    error_message = "resource_aws_auditmanager_framework_share, framework_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_auditmanager_framework_share, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}

variable "comment" {
  description = "Comment from the sender about the share request."
  type        = string
  default     = null

  validation {
    condition     = var.comment == null || length(var.comment) <= 512
    error_message = "resource_aws_auditmanager_framework_share, comment must not exceed 512 characters."
  }
}