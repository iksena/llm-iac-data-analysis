variable "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = length(var.instance_id) > 0
    error_message = "resource_aws_connect_vocabulary, instance_id must not be empty."
  }
}

variable "name" {
  description = "A unique name of the custom vocabulary. Must not be more than 140 characters"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 140
    error_message = "resource_aws_connect_vocabulary, name must be between 1 and 140 characters."
  }
}

variable "content" {
  description = "The content of the custom vocabulary in plain-text format with a table of values. Each row in the table represents a word or a phrase, described with Phrase, IPA, SoundsLike, and DisplayAs fields. Separate the fields with TAB characters"
  type        = string

  validation {
    condition     = length(var.content) >= 1 && length(var.content) <= 60000
    error_message = "resource_aws_connect_vocabulary, content must be between 1 and 60000 characters."
  }
}

variable "language_code" {
  description = "The language code of the vocabulary entries"
  type        = string

  validation {
    condition = contains([
      "ar-AE", "de-CH", "de-DE", "en-AB", "en-AU", "en-GB", "en-IE", "en-IN",
      "en-US", "en-WL", "es-ES", "es-US", "fr-CA", "fr-FR", "hi-IN", "it-IT",
      "ja-JP", "ko-KR", "pt-BR", "pt-PT", "zh-CN"
    ], var.language_code)
    error_message = "resource_aws_connect_vocabulary, language_code must be one of: ar-AE, de-CH, de-DE, en-AB, en-AU, en-GB, en-IE, en-IN, en-US, en-WL, es-ES, es-US, fr-CA, fr-FR, hi-IN, it-IT, ja-JP, ko-KR, pt-BR, pt-PT, zh-CN."
  }
}

variable "tags" {
  description = "Tags to apply to the vocabulary"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Timeout configurations for create and delete operations"
  type = object({
    create = optional(string, "5m")
    delete = optional(string, "100m")
  })
  default = {
    create = "5m"
    delete = "100m"
  }
}