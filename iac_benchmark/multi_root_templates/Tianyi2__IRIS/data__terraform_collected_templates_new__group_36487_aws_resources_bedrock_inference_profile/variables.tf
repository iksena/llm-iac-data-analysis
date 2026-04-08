variable "name" {
  description = "The name of the inference profile"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_bedrock_inference_profile, name must not be empty."
  }
}

variable "model_source_copy_from" {
  description = "The Amazon Resource Name (ARN) of the model"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:bedrock:", var.model_source_copy_from))
    error_message = "resource_aws_bedrock_inference_profile, model_source_copy_from must be a valid Bedrock ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the inference profile"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags for the inference profile"
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Timeout for creating the inference profile"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_bedrock_inference_profile, timeouts_create must be a valid timeout format (e.g., '5m', '30s', '1h')."
  }
}

variable "timeouts_update" {
  description = "Timeout for updating the inference profile"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_bedrock_inference_profile, timeouts_update must be a valid timeout format (e.g., '5m', '30s', '1h')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the inference profile"
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_bedrock_inference_profile, timeouts_delete must be a valid timeout format (e.g., '5m', '30s', '1h')."
  }
}