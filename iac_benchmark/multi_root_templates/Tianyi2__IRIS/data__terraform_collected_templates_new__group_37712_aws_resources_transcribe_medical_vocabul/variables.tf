variable "vocabulary_name" {
  description = "The name of the Medical Vocabulary."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.vocabulary_name))
    error_message = "resource_aws_transcribe_medical_vocabulary, vocabulary_name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "language_code" {
  description = "The language code you selected for your medical vocabulary. US English (en-US) is the only language supported with Amazon Transcribe Medical."
  type        = string

  validation {
    condition     = var.language_code == "en-US"
    error_message = "resource_aws_transcribe_medical_vocabulary, language_code must be 'en-US' as it is the only supported language code."
  }
}

variable "vocabulary_file_uri" {
  description = "The Amazon S3 location (URI) of the text file that contains your custom medical vocabulary."
  type        = string

  validation {
    condition     = can(regex("^s3://", var.vocabulary_file_uri))
    error_message = "resource_aws_transcribe_medical_vocabulary, vocabulary_file_uri must be a valid S3 URI starting with 's3://'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the MedicalVocabulary. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for operation timeouts."
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null

  validation {
    condition = var.timeouts == null || alltrue([
      for timeout_value in values(var.timeouts) :
      timeout_value == null || can(regex("^[0-9]+(s|m|h)$", timeout_value))
    ])
    error_message = "resource_aws_transcribe_medical_vocabulary, timeouts values must be valid duration strings (e.g., '30m', '1h', '60s') or null."
  }
}