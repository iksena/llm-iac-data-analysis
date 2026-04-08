variable "name" {
  description = "The name or description of the SQL Injection Match Set"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_waf_sql_injection_match_set, name must not be empty."
  }
}

variable "sql_injection_match_tuples" {
  description = "The parts of web requests that you want AWS WAF to inspect for malicious SQL code and, if you want AWS WAF to inspect a header, the name of the header"
  type = list(object({
    text_transformation = string
    field_to_match = object({
      data = optional(string)
      type = string
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for tuple in var.sql_injection_match_tuples :
      contains([
        "NONE", "COMPRESS_WHITE_SPACE", "HTML_ENTITY_DECODE", "LOWERCASE", "CMD_LINE", "URL_DECODE"
      ], tuple.text_transformation)
    ])
    error_message = "resource_aws_waf_sql_injection_match_set, text_transformation must be one of: NONE, COMPRESS_WHITE_SPACE, HTML_ENTITY_DECODE, LOWERCASE, CMD_LINE, URL_DECODE."
  }

  validation {
    condition = alltrue([
      for tuple in var.sql_injection_match_tuples :
      contains([
        "URI", "QUERY_STRING", "HEADER", "METHOD", "BODY", "SINGLE_QUERY_ARG", "ALL_QUERY_ARGS"
      ], tuple.field_to_match.type)
    ])
    error_message = "resource_aws_waf_sql_injection_match_set, field_to_match.type must be one of: URI, QUERY_STRING, HEADER, METHOD, BODY, SINGLE_QUERY_ARG, ALL_QUERY_ARGS."
  }

  validation {
    condition = alltrue([
      for tuple in var.sql_injection_match_tuples :
      tuple.field_to_match.type == "HEADER" ? tuple.field_to_match.data != null : tuple.field_to_match.data == null || tuple.field_to_match.data == ""
    ])
    error_message = "resource_aws_waf_sql_injection_match_set, field_to_match.data is required when type is HEADER and should be omitted for other types."
  }
}