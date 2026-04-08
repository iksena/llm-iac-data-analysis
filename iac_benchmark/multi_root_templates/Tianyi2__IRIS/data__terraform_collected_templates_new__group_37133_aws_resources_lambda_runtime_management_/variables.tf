variable "function_name" {
  description = "Name or ARN of the Lambda function"
  type        = string
}

variable "qualifier" {
  description = "Version of the function. This can be $LATEST or a published version number. If omitted, this resource will manage the runtime configuration for $LATEST"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "runtime_version_arn" {
  description = "ARN of the runtime version. Only required when update_runtime_on is Manual"
  type        = string
  default     = null
}

variable "update_runtime_on" {
  description = "Runtime update mode. Valid values are Auto, FunctionUpdate, and Manual. When a function is created, the default mode is Auto"
  type        = string
  default     = null

  validation {
    condition     = var.update_runtime_on == null || contains(["Auto", "FunctionUpdate", "Manual"], var.update_runtime_on)
    error_message = "resource_aws_lambda_runtime_management_config, update_runtime_on must be one of: Auto, FunctionUpdate, Manual."
  }
}