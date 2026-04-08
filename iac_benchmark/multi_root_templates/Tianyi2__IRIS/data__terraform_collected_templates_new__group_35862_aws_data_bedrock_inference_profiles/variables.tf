variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_bedrock_inference_profiles, region must be a valid AWS region format."
  }
}

variable "type" {
  description = "Filters for inference profiles that match the type you specify. Valid values are: SYSTEM_DEFINED, APPLICATION."
  type        = string
  default     = null

  validation {
    condition     = var.type == null || contains(["SYSTEM_DEFINED", "APPLICATION"], var.type)
    error_message = "data_aws_bedrock_inference_profiles, type must be either 'SYSTEM_DEFINED' or 'APPLICATION'."
  }
}