variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "embedding_data_delivery_enabled" {
  description = "Set to include embeddings data in the log delivery. Defaults to true."
  type        = bool
  default     = true
}

variable "image_data_delivery_enabled" {
  description = "Set to include image data in the log delivery. Defaults to true."
  type        = bool
  default     = true
}

variable "text_data_delivery_enabled" {
  description = "Set to include text data in the log delivery. Defaults to true."
  type        = bool
  default     = true
}

variable "video_data_delivery_enabled" {
  description = "Set to include video data in the log delivery. Defaults to true."
  type        = bool
  default     = true
}

variable "cloudwatch_config" {
  description = "CloudWatch logging configuration"
  type = object({
    log_group_name = string
    role_arn       = optional(string)
    large_data_delivery_s3_config = optional(object({
      bucket_name = string
      key_prefix  = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.cloudwatch_config == null || (
      var.cloudwatch_config.log_group_name != null &&
      var.cloudwatch_config.log_group_name != ""
    )
    error_message = "resource_aws_bedrock_model_invocation_logging_configuration, cloudwatch_config: log_group_name is required when cloudwatch_config is specified."
  }

  validation {
    condition = var.cloudwatch_config == null || var.cloudwatch_config.large_data_delivery_s3_config == null || (
      var.cloudwatch_config.large_data_delivery_s3_config.bucket_name != null &&
      var.cloudwatch_config.large_data_delivery_s3_config.bucket_name != ""
    )
    error_message = "resource_aws_bedrock_model_invocation_logging_configuration, large_data_delivery_s3_config: bucket_name is required when large_data_delivery_s3_config is specified."
  }
}

variable "s3_config" {
  description = "S3 configuration for storing log data"
  type = object({
    bucket_name = string
    key_prefix  = optional(string)
  })
  default = null

  validation {
    condition = var.s3_config == null || (
      var.s3_config.bucket_name != null &&
      var.s3_config.bucket_name != ""
    )
    error_message = "resource_aws_bedrock_model_invocation_logging_configuration, s3_config: bucket_name is required when s3_config is specified."
  }
}