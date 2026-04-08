variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "base_model_name" {
  description = "Name of reference base model"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.base_model_name))
    error_message = "resource_aws_transcribe_language_model, base_model_name must be a valid base model name containing only alphanumeric characters, hyphens, and underscores."
  }
}

variable "input_data_config" {
  description = "The input data config for the LanguageModel"
  type = object({
    data_access_role_arn = string
    s3_uri               = string
    tuning_data_s3_uri   = optional(string)
  })

  validation {
    condition     = can(regex("^arn:aws:iam::", var.input_data_config.data_access_role_arn))
    error_message = "resource_aws_transcribe_language_model, data_access_role_arn must be a valid IAM role ARN."
  }

  validation {
    condition     = can(regex("^s3://", var.input_data_config.s3_uri))
    error_message = "resource_aws_transcribe_language_model, s3_uri must be a valid S3 URI starting with s3://."
  }

  validation {
    condition     = var.input_data_config.tuning_data_s3_uri == null || can(regex("^s3://", var.input_data_config.tuning_data_s3_uri))
    error_message = "resource_aws_transcribe_language_model, tuning_data_s3_uri must be a valid S3 URI starting with s3:// or null."
  }
}

variable "language_code" {
  description = "The language code you selected for your language model"
  type        = string

  validation {
    condition = contains([
      "en-US", "es-US", "en-AU", "fr-CA", "en-GB", "de-DE", "pt-BR", "fr-FR",
      "it-IT", "ko-KR", "es-ES", "en-IN", "hi-IN", "ar-SA", "ru-RU", "zh-CN",
      "nl-NL", "id-ID", "ta-IN", "fa-IR", "en-IE", "en-AB", "en-WL", "pt-PT",
      "te-IN", "tr-TR", "de-CH", "he-IL", "ms-MY", "ja-JP", "ar-AE"
    ], var.language_code)
    error_message = "resource_aws_transcribe_language_model, language_code must be a supported language code."
  }
}

variable "model_name" {
  description = "The model name"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.model_name))
    error_message = "resource_aws_transcribe_language_model, model_name must contain only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = length(var.model_name) >= 1 && length(var.model_name) <= 200
    error_message = "resource_aws_transcribe_language_model, model_name must be between 1 and 200 characters long."
  }
}

variable "tags" {
  description = "A map of tags to assign to the LanguageModel"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "600m")
  })
  default = {}
}