variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "human_task_ui_name" {
  description = "The name of the Human Task UI."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-]{1,63}$", var.human_task_ui_name))
    error_message = "resource_aws_sagemaker_human_task_ui, human_task_ui_name must be between 1 and 63 characters and can only contain letters, numbers, and hyphens."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "ui_template_content" {
  description = "The content of the Liquid template for the worker user interface."
  type        = string

  validation {
    condition     = length(var.ui_template_content) > 0
    error_message = "resource_aws_sagemaker_human_task_ui, ui_template_content cannot be empty."
  }
}