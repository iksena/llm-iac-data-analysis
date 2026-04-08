variable "name" {
  description = "The name or description of the Regex Match Set"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_waf_regex_match_set, name must be a non-empty string."
  }
}

variable "regex_match_tuples" {
  description = "The regular expression pattern that you want AWS WAF to search for in web requests, the location in requests that you want AWS WAF to search, and other settings"
  type = list(object({
    field_to_match = object({
      data = optional(string)
      type = string
    })
    regex_pattern_set_id = string
    text_transformation  = string
  }))

  validation {
    condition     = length(var.regex_match_tuples) > 0
    error_message = "resource_aws_waf_regex_match_set, regex_match_tuples must contain at least one tuple."
  }

  validation {
    condition = alltrue([
      for tuple in var.regex_match_tuples : contains([
        "CMD_LINE", "HTML_ENTITY_DECODE", "NONE", "COMPRESS_WHITE_SPACE",
        "URL_DECODE", "LOWERCASE"
      ], tuple.text_transformation)
    ])
    error_message = "resource_aws_waf_regex_match_set, text_transformation must be one of: CMD_LINE, HTML_ENTITY_DECODE, NONE, COMPRESS_WHITE_SPACE, URL_DECODE, LOWERCASE."
  }

  validation {
    condition = alltrue([
      for tuple in var.regex_match_tuples : contains([
        "URI", "QUERY_STRING", "HEADER", "METHOD", "BODY", "SINGLE_QUERY_ARG", "ALL_QUERY_ARGS"
      ], tuple.field_to_match.type)
    ])
    error_message = "resource_aws_waf_regex_match_set, field_to_match.type must be one of: URI, QUERY_STRING, HEADER, METHOD, BODY, SINGLE_QUERY_ARG, ALL_QUERY_ARGS."
  }

  validation {
    condition = alltrue([
      for tuple in var.regex_match_tuples :
      tuple.field_to_match.type != "HEADER" || (tuple.field_to_match.type == "HEADER" && tuple.field_to_match.data != null)
    ])
    error_message = "resource_aws_waf_regex_match_set, field_to_match.data is required when field_to_match.type is HEADER."
  }

  validation {
    condition = alltrue([
      for tuple in var.regex_match_tuples :
      tuple.field_to_match.type == "HEADER" || (tuple.field_to_match.type != "HEADER" && tuple.field_to_match.data == null)
    ])
    error_message = "resource_aws_waf_regex_match_set, field_to_match.data should only be specified when field_to_match.type is HEADER."
  }

  validation {
    condition = alltrue([
      for tuple in var.regex_match_tuples : length(tuple.regex_pattern_set_id) > 0
    ])
    error_message = "resource_aws_waf_regex_match_set, regex_pattern_set_id must be a non-empty string."
  }
}