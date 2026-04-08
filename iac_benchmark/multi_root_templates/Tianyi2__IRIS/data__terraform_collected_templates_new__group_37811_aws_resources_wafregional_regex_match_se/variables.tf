variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name or description of the Regex Match Set."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name)) && length(var.name) > 0 && length(var.name) <= 128
    error_message = "resource_aws_wafregional_regex_match_set, name must be a valid name containing only alphanumeric characters, hyphens, and underscores, and must be between 1 and 128 characters long."
  }
}

variable "regex_match_tuple" {
  description = "The regular expression pattern that you want AWS WAF to search for in web requests, the location in requests that you want AWS WAF to search, and other settings."
  type = list(object({
    field_to_match = object({
      data = optional(string)
      type = string
    })
    regex_pattern_set_id = string
    text_transformation  = string
  }))

  validation {
    condition     = length(var.regex_match_tuple) > 0
    error_message = "resource_aws_wafregional_regex_match_set, regex_match_tuple must contain at least one tuple."
  }

  validation {
    condition = alltrue([
      for tuple in var.regex_match_tuple : contains([
        "HEADER", "METHOD", "QUERY_STRING", "URI", "BODY", "SINGLE_QUERY_ARG", "ALL_QUERY_ARGS"
      ], tuple.field_to_match.type)
    ])
    error_message = "resource_aws_wafregional_regex_match_set, field_to_match.type must be one of: HEADER, METHOD, QUERY_STRING, URI, BODY, SINGLE_QUERY_ARG, ALL_QUERY_ARGS."
  }

  validation {
    condition = alltrue([
      for tuple in var.regex_match_tuple : contains([
        "NONE", "COMPRESS_WHITE_SPACE", "HTML_ENTITY_DECODE", "LOWERCASE", "CMD_LINE", "URL_DECODE"
      ], tuple.text_transformation)
    ])
    error_message = "resource_aws_wafregional_regex_match_set, text_transformation must be one of: NONE, COMPRESS_WHITE_SPACE, HTML_ENTITY_DECODE, LOWERCASE, CMD_LINE, URL_DECODE."
  }

  validation {
    condition = alltrue([
      for tuple in var.regex_match_tuple :
      tuple.field_to_match.type != "HEADER" || (tuple.field_to_match.type == "HEADER" && tuple.field_to_match.data != null)
    ])
    error_message = "resource_aws_wafregional_regex_match_set, field_to_match.data is required when field_to_match.type is HEADER."
  }

  validation {
    condition = alltrue([
      for tuple in var.regex_match_tuple :
      tuple.field_to_match.type == "HEADER" || (tuple.field_to_match.type != "HEADER" && tuple.field_to_match.data == null)
    ])
    error_message = "resource_aws_wafregional_regex_match_set, field_to_match.data should be omitted when field_to_match.type is not HEADER."
  }

  validation {
    condition = alltrue([
      for tuple in var.regex_match_tuple : can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", tuple.regex_pattern_set_id))
    ])
    error_message = "resource_aws_wafregional_regex_match_set, regex_pattern_set_id must be a valid UUID format."
  }
}