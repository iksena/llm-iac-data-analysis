variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "studio_lifecycle_config_name" {
  description = "The name of the Studio Lifecycle Configuration to create"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-]{1,63}$", var.studio_lifecycle_config_name))
    error_message = "resource_aws_sagemaker_studio_lifecycle_config, studio_lifecycle_config_name must be between 1-63 characters and can only contain letters, numbers, and hyphens."
  }
}

variable "studio_lifecycle_config_app_type" {
  description = "The App type that the Lifecycle Configuration is attached to"
  type        = string

  validation {
    condition     = contains(["JupyterServer", "JupyterLab", "CodeEditor", "KernelGateway"], var.studio_lifecycle_config_app_type)
    error_message = "resource_aws_sagemaker_studio_lifecycle_config, studio_lifecycle_config_app_type must be one of: JupyterServer, JupyterLab, CodeEditor, KernelGateway."
  }
}

variable "studio_lifecycle_config_content" {
  description = "The content of your Studio Lifecycle Configuration script (must be base64 encoded)"
  type        = string

  validation {
    condition     = can(base64decode(var.studio_lifecycle_config_content))
    error_message = "resource_aws_sagemaker_studio_lifecycle_config, studio_lifecycle_config_content must be valid base64 encoded content."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}