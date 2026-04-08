variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "approval_rule_template_name" {
  description = "The name for the approval rule template."
  type        = string

  validation {
    condition     = length(var.approval_rule_template_name) > 0
    error_message = "resource_aws_codecommit_approval_rule_template_association, approval_rule_template_name cannot be empty."
  }
}

variable "repository_name" {
  description = "The name of the repository that you want to associate with the template."
  type        = string

  validation {
    condition     = length(var.repository_name) > 0
    error_message = "resource_aws_codecommit_approval_rule_template_association, repository_name cannot be empty."
  }
}