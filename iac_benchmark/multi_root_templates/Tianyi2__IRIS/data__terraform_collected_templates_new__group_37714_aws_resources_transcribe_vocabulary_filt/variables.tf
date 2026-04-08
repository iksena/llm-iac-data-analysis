variable "language_code" {
  description = "The language code you selected for your vocabulary filter. Refer to the supported languages page for accepted codes."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[A-Z]{2}$", var.language_code))
    error_message = "resource_aws_transcribe_vocabulary_filter, language_code must be in the format 'xx-XX' where xx is the language code and XX is the country code (e.g., 'en-US')."
  }
}

variable "vocabulary_filter_name" {
  description = "The name of the VocabularyFilter."
  type        = string

  validation {
    condition     = length(var.vocabulary_filter_name) >= 1 && length(var.vocabulary_filter_name) <= 200
    error_message = "resource_aws_transcribe_vocabulary_filter, vocabulary_filter_name must be between 1 and 200 characters in length."
  }

  validation {
    condition     = can(regex("^[0-9A-Za-z._-]+$", var.vocabulary_filter_name))
    error_message = "resource_aws_transcribe_vocabulary_filter, vocabulary_filter_name can only contain alphanumeric characters, periods, hyphens, and underscores."
  }
}

variable "vocabulary_filter_file_uri" {
  description = "The Amazon S3 location (URI) of the text file that contains your custom VocabularyFilter. Conflicts with words argument."
  type        = string
  default     = null

  validation {
    condition     = var.vocabulary_filter_file_uri == null || can(regex("^s3://", var.vocabulary_filter_file_uri))
    error_message = "resource_aws_transcribe_vocabulary_filter, vocabulary_filter_file_uri must be a valid S3 URI starting with 's3://'."
  }
}

variable "words" {
  description = "A list of terms to include in the vocabulary. Conflicts with vocabulary_filter_file_uri argument."
  type        = list(string)
  default     = null

  validation {
    condition     = var.words == null || (length(var.words) >= 1 && length(var.words) <= 256)
    error_message = "resource_aws_transcribe_vocabulary_filter, words list must contain between 1 and 256 items when specified."
  }
}

variable "tags" {
  description = "A map of tags to assign to the VocabularyFilter. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}