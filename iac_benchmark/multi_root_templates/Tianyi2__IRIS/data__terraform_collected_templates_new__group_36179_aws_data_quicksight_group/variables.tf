variable "group_name" {
  description = "The name of the group that you want to match."
  type        = string

  validation {
    condition     = length(var.group_name) > 0
    error_message = "data_aws_quicksight_group, group_name must not be empty."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null
}

variable "namespace" {
  description = "QuickSight namespace. Defaults to default."
  type        = string
  default     = "default"

  validation {
    condition     = length(var.namespace) > 0
    error_message = "data_aws_quicksight_group, namespace must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}