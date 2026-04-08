variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "content" {
  description = "The content of the approval rule template"
  type        = string

  validation {
    condition     = length(var.content) <= 3000
    error_message = "resource_aws_codecommit_approval_rule_template, content must be at most 3000 characters."
  }
}

variable "name" {
  description = "The name for the approval rule template"
  type        = string

  validation {
    condition     = length(var.name) <= 100
    error_message = "resource_aws_codecommit_approval_rule_template, name must be at most 100 characters."
  }
}

variable "description" {
  description = "The description of the approval rule template"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1000
    error_message = "resource_aws_codecommit_approval_rule_template, description must be at most 1000 characters."
  }
}