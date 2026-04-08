variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_wafregional_regex_pattern_set, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}

variable "name" {
  description = "The name or description of the Regex Pattern Set."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "resource_aws_wafregional_regex_pattern_set, name must be between 1 and 128 characters."
  }
}

variable "regex_pattern_strings" {
  description = "A list of regular expression (regex) patterns that you want AWS WAF to search for, such as B[a@]dB[o0]t."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.regex_pattern_strings) <= 10
    error_message = "resource_aws_wafregional_regex_pattern_set, regex_pattern_strings can contain at most 10 patterns."
  }

  validation {
    condition = alltrue([
      for pattern in var.regex_pattern_strings : length(pattern) <= 512
    ])
    error_message = "resource_aws_wafregional_regex_pattern_set, regex_pattern_strings each pattern must be 512 characters or less."
  }
}