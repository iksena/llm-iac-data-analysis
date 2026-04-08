variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "inference_profile_id" {
  description = "Inference Profile identifier."
  type        = string

  validation {
    condition     = var.inference_profile_id != null && var.inference_profile_id != ""
    error_message = "data_aws_bedrock_inference_profile, inference_profile_id must be a non-empty string."
  }
}