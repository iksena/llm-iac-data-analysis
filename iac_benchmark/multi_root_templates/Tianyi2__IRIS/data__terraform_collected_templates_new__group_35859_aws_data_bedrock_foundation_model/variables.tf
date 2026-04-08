variable "model_id" {
  description = "Model identifier."
  type        = string

  validation {
    condition     = length(var.model_id) > 0
    error_message = "data_aws_bedrock_foundation_model, model_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}