variable "language_code" {
  description = "The language code you selected for your vocabulary"
  type        = string

  validation {
    condition     = length(var.language_code) > 0
    error_message = "resource_aws_transcribe_vocabulary, language_code must not be empty."
  }
}

variable "vocabulary_name" {
  description = "The name of the Vocabulary"
  type        = string

  validation {
    condition     = length(var.vocabulary_name) > 0
    error_message = "resource_aws_transcribe_vocabulary, vocabulary_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "phrases" {
  description = "A list of terms to include in the vocabulary. Conflicts with vocabulary_file_uri"
  type        = list(string)
  default     = null
}

variable "vocabulary_file_uri" {
  description = "The Amazon S3 location (URI) of the text file that contains your custom vocabulary. Conflicts with phrases"
  type        = string
  default     = null

  validation {
    condition     = var.vocabulary_file_uri == null || can(regex("^s3://", var.vocabulary_file_uri))
    error_message = "resource_aws_transcribe_vocabulary, vocabulary_file_uri must be a valid S3 URI starting with 's3://'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the Vocabulary"
  type        = map(string)
  default     = {}
}

variable "timeout_create" {
  description = "Timeout for create operation"
  type        = string
  default     = "30m"
}

variable "timeout_update" {
  description = "Timeout for update operation"
  type        = string
  default     = "30m"
}

variable "timeout_delete" {
  description = "Timeout for delete operation"
  type        = string
  default     = "30m"
}