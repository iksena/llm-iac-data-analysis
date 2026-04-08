variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null
}

variable "description" {
  description = "A description for the group."
  type        = string
  default     = null
}

variable "group_name" {
  description = "A name for the group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.group_name)) && length(var.group_name) > 0
    error_message = "resource_aws_quicksight_group, group_name must be a non-empty string containing only alphanumeric characters, underscores, periods, and hyphens."
  }
}

variable "namespace" {
  description = "The namespace. Currently, you should set this to default."
  type        = string
  default     = "default"

  validation {
    condition     = var.namespace == "default"
    error_message = "resource_aws_quicksight_group, namespace must be set to 'default'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}