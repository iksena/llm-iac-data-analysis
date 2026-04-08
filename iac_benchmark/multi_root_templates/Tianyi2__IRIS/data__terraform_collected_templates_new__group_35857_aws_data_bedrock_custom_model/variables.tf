variable "model_id" {
  description = "Name or ARN of the custom model."
  type        = string

  validation {
    condition     = can(regex("^(arn:aws:bedrock:[^:]+:[^:]+:custom-model/|[^:]+)", var.model_id))
    error_message = "data_aws_bedrock_custom_model, model_id must be a valid model name or ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_bedrock_custom_model, region must be a valid AWS region format (e.g., us-west-2)."
  }
}