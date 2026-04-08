variable "name" {
  description = "The name or description of the Regex Pattern Set"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_waf_regex_pattern_set, name must not be empty."
  }
}

variable "regex_pattern_strings" {
  description = "A list of regular expression (regex) patterns that you want AWS WAF to search for"
  type        = list(string)
  default     = null

  validation {
    condition     = var.regex_pattern_strings == null || length(var.regex_pattern_strings) >= 0
    error_message = "resource_aws_waf_regex_pattern_set, regex_pattern_strings must be a valid list of strings."
  }
}