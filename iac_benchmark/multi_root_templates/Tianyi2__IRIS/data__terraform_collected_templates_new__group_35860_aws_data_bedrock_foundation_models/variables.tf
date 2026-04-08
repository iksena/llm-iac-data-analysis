variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "by_customization_type" {
  description = "Customization type to filter on."
  type        = string
  default     = null

  validation {
    condition     = var.by_customization_type == null || contains(["FINE_TUNING"], var.by_customization_type)
    error_message = "data_aws_bedrock_foundation_models, by_customization_type must be one of: FINE_TUNING."
  }
}

variable "by_inference_type" {
  description = "Inference type to filter on."
  type        = string
  default     = null

  validation {
    condition     = var.by_inference_type == null || contains(["ON_DEMAND", "PROVISIONED"], var.by_inference_type)
    error_message = "data_aws_bedrock_foundation_models, by_inference_type must be one of: ON_DEMAND, PROVISIONED."
  }
}

variable "by_output_modality" {
  description = "Output modality to filter on."
  type        = string
  default     = null

  validation {
    condition     = var.by_output_modality == null || contains(["TEXT", "IMAGE", "EMBEDDING"], var.by_output_modality)
    error_message = "data_aws_bedrock_foundation_models, by_output_modality must be one of: TEXT, IMAGE, EMBEDDING."
  }
}

variable "by_provider" {
  description = "Model provider to filter on."
  type        = string
  default     = null
}