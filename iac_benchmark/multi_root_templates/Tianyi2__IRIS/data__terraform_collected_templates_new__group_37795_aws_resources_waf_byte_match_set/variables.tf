variable "name" {
  description = "The name or description of the Byte Match Set"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_waf_byte_match_set, name must be a non-empty string."
  }
}

variable "byte_match_tuples" {
  description = "Specifies the bytes (typically a string that corresponds with ASCII characters) that you want to search for in web requests, the location in requests that you want to search, and other settings"
  type = list(object({
    text_transformation   = string
    target_string         = optional(string)
    positional_constraint = string
    field_to_match = object({
      type = string
      data = optional(string)
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for tuple in var.byte_match_tuples : contains([
        "NONE", "COMPRESS_WHITE_SPACE", "HTML_ENTITY_DECODE", "LOWERCASE", "CMD_LINE", "URL_DECODE"
      ], tuple.text_transformation)
    ])
    error_message = "resource_aws_waf_byte_match_set, text_transformation must be one of: NONE, COMPRESS_WHITE_SPACE, HTML_ENTITY_DECODE, LOWERCASE, CMD_LINE, URL_DECODE."
  }

  validation {
    condition = alltrue([
      for tuple in var.byte_match_tuples : contains([
        "EXACTLY", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CONTAINS_WORD"
      ], tuple.positional_constraint)
    ])
    error_message = "resource_aws_waf_byte_match_set, positional_constraint must be one of: EXACTLY, STARTS_WITH, ENDS_WITH, CONTAINS, CONTAINS_WORD."
  }

  validation {
    condition = alltrue([
      for tuple in var.byte_match_tuples : contains([
        "URI", "QUERY_STRING", "HEADER", "METHOD", "BODY", "SINGLE_QUERY_ARG", "ALL_QUERY_ARGS"
      ], tuple.field_to_match.type)
    ])
    error_message = "resource_aws_waf_byte_match_set, field_to_match.type must be one of: URI, QUERY_STRING, HEADER, METHOD, BODY, SINGLE_QUERY_ARG, ALL_QUERY_ARGS."
  }

  validation {
    condition = alltrue([
      for tuple in var.byte_match_tuples :
      tuple.field_to_match.type == "HEADER" ? tuple.field_to_match.data != null : true
    ])
    error_message = "resource_aws_waf_byte_match_set, field_to_match.data is required when field_to_match.type is HEADER."
  }

  validation {
    condition = alltrue([
      for tuple in var.byte_match_tuples :
      tuple.field_to_match.type != "HEADER" ? tuple.field_to_match.data == null : true
    ])
    error_message = "resource_aws_waf_byte_match_set, field_to_match.data must be omitted when field_to_match.type is not HEADER."
  }
}