variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name or description of the SqlInjectionMatchSet."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_wafregional_sql_injection_match_set, name must not be empty."
  }
}

variable "sql_injection_match_tuple" {
  description = "The parts of web requests that you want AWS WAF to inspect for malicious SQL code and, if you want AWS WAF to inspect a header, the name of the header."
  type = list(object({
    field_to_match = object({
      data = optional(string)
      type = string
    })
    text_transformation = string
  }))
  default = []

  validation {
    condition = alltrue([
      for tuple in var.sql_injection_match_tuple : contains([
        "CMD_LINE", "HTML_ENTITY_DECODE", "NONE", "COMPRESS_WHITE_SPACE",
        "URL_DECODE", "LOWERCASE"
      ], tuple.text_transformation)
    ])
    error_message = "resource_aws_wafregional_sql_injection_match_set, text_transformation must be one of: CMD_LINE, HTML_ENTITY_DECODE, NONE, COMPRESS_WHITE_SPACE, URL_DECODE, LOWERCASE."
  }

  validation {
    condition = alltrue([
      for tuple in var.sql_injection_match_tuple : contains([
        "URI", "QUERY_STRING", "HEADER", "METHOD", "BODY", "SINGLE_QUERY_ARG", "ALL_QUERY_ARGS"
      ], tuple.field_to_match.type)
    ])
    error_message = "resource_aws_wafregional_sql_injection_match_set, field_to_match.type must be one of: URI, QUERY_STRING, HEADER, METHOD, BODY, SINGLE_QUERY_ARG, ALL_QUERY_ARGS."
  }

  validation {
    condition = alltrue([
      for tuple in var.sql_injection_match_tuple :
      tuple.field_to_match.type == "HEADER" ? tuple.field_to_match.data != null && tuple.field_to_match.data != "" : tuple.field_to_match.data == null
    ])
    error_message = "resource_aws_wafregional_sql_injection_match_set, field_to_match.data must be provided when type is HEADER and must be omitted for all other types."
  }
}