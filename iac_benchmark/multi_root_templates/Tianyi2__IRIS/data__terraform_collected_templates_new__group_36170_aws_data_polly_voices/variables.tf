variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "engine" {
  type        = string
  description = "Engine used by Amazon Polly when processing input text for speech synthesis. Valid values are standard, neural, and long-form."
  default     = null

  validation {
    condition     = var.engine == null || contains(["standard", "neural", "long-form"], var.engine)
    error_message = "data_aws_polly_voices, engine must be one of: standard, neural, long-form."
  }
}

variable "include_additional_language_codes" {
  type        = bool
  description = "Whether to return any bilingual voices that use the specified language as an additional language."
  default     = null
}

variable "language_code" {
  type        = string
  description = "Language identification tag for filtering the list of voices returned. If not specified, all available voices are returned."
  default     = null
}