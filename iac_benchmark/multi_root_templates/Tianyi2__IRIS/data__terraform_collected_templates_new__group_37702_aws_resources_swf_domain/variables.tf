variable "name" {
  description = "The name of the domain. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || var.name_prefix == null
    error_message = "resource_aws_swf_domain, name_prefix: conflicts with name. Only one of name or name_prefix can be specified."
  }
}

variable "description" {
  description = "The domain description."
  type        = string
  default     = null
}

variable "workflow_execution_retention_period_in_days" {
  description = "Length of time that SWF will continue to retain information about the workflow execution after the workflow execution is complete, must be between 0 and 90 days."
  type        = number

  validation {
    condition     = var.workflow_execution_retention_period_in_days >= 0 && var.workflow_execution_retention_period_in_days <= 90
    error_message = "resource_aws_swf_domain, workflow_execution_retention_period_in_days: must be between 0 and 90 days."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}