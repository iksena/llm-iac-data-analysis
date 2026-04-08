variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "regex" {
  description = "The regular expression (regex) that defines the pattern to match. The expression can contain as many as 512 characters."
  type        = string
  default     = null

  validation {
    condition     = var.regex == null || length(var.regex) <= 512
    error_message = "resource_aws_macie2_custom_data_identifier, regex can contain as many as 512 characters."
  }
}

variable "keywords" {
  description = "An array that lists specific character sequences (keywords), one of which must be within proximity (maximum_match_distance) of the regular expression to match. The array can contain as many as 50 keywords. Each keyword can contain 3 - 90 characters. Keywords aren't case sensitive."
  type        = list(string)
  default     = null

  validation {
    condition     = var.keywords == null || length(var.keywords) <= 50
    error_message = "resource_aws_macie2_custom_data_identifier, keywords array can contain as many as 50 keywords."
  }

  validation {
    condition = var.keywords == null || alltrue([
      for keyword in var.keywords : length(keyword) >= 3 && length(keyword) <= 90
    ])
    error_message = "resource_aws_macie2_custom_data_identifier, keywords each keyword can contain 3 - 90 characters."
  }
}

variable "ignore_words" {
  description = "An array that lists specific character sequences (ignore words) to exclude from the results. If the text matched by the regular expression is the same as any string in this array, Amazon Macie ignores it. The array can contain as many as 10 ignore words. Each ignore word can contain 4 - 90 characters. Ignore words are case sensitive."
  type        = list(string)
  default     = null

  validation {
    condition     = var.ignore_words == null || length(var.ignore_words) <= 10
    error_message = "resource_aws_macie2_custom_data_identifier, ignore_words array can contain as many as 10 ignore words."
  }

  validation {
    condition = var.ignore_words == null || alltrue([
      for ignore_word in var.ignore_words : length(ignore_word) >= 4 && length(ignore_word) <= 90
    ])
    error_message = "resource_aws_macie2_custom_data_identifier, ignore_words each ignore word can contain 4 - 90 characters."
  }
}

variable "name" {
  description = "A custom name for the custom data identifier. The name can contain as many as 128 characters. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) <= 128
    error_message = "resource_aws_macie2_custom_data_identifier, name can contain as many as 128 characters."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "description" {
  description = "A custom description of the custom data identifier. The description can contain as many as 512 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 512
    error_message = "resource_aws_macie2_custom_data_identifier, description can contain as many as 512 characters."
  }
}

variable "maximum_match_distance" {
  description = "The maximum number of characters that can exist between text that matches the regex pattern and the character sequences specified by the keywords array. Macie includes or excludes a result based on the proximity of a keyword to text that matches the regex pattern. The distance can be 1 - 300 characters. The default value is 50."
  type        = number
  default     = null

  validation {
    condition     = var.maximum_match_distance == null || (var.maximum_match_distance >= 1 && var.maximum_match_distance <= 300)
    error_message = "resource_aws_macie2_custom_data_identifier, maximum_match_distance can be 1 - 300 characters."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}