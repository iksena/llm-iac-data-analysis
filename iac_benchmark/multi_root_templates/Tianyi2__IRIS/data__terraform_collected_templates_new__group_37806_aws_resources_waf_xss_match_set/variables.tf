variable "name" {
  description = "The name or description of the SizeConstraintSet"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_waf_xss_match_set, name must not be empty."
  }
}

variable "xss_match_tuples" {
  description = "The parts of web requests that you want to inspect for cross-site scripting attacks"
  type = list(object({
    text_transformation = string
    field_to_match = object({
      type = string
      data = optional(string)
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for tuple in var.xss_match_tuples : contains([
        "CMD_LINE", "HTML_ENTITY_DECODE", "NONE", "COMPRESS_WHITE_SPACE", "URL_DECODE"
      ], tuple.text_transformation)
    ])
    error_message = "resource_aws_waf_xss_match_set, text_transformation must be one of: CMD_LINE, HTML_ENTITY_DECODE, NONE, COMPRESS_WHITE_SPACE, URL_DECODE."
  }

  validation {
    condition = alltrue([
      for tuple in var.xss_match_tuples : contains([
        "URI", "QUERY_STRING", "HEADER", "METHOD", "BODY", "SINGLE_QUERY_ARG", "ALL_QUERY_ARGS"
      ], tuple.field_to_match.type)
    ])
    error_message = "resource_aws_waf_xss_match_set, field_to_match.type must be one of: URI, QUERY_STRING, HEADER, METHOD, BODY, SINGLE_QUERY_ARG, ALL_QUERY_ARGS."
  }

  validation {
    condition = alltrue([
      for tuple in var.xss_match_tuples :
      tuple.field_to_match.type == "HEADER" ? tuple.field_to_match.data != null : true
    ])
    error_message = "resource_aws_waf_xss_match_set, field_to_match.data is required when field_to_match.type is HEADER."
  }

  validation {
    condition = alltrue([
      for tuple in var.xss_match_tuples :
      tuple.field_to_match.type != "HEADER" ? tuple.field_to_match.data == null : true
    ])
    error_message = "resource_aws_waf_xss_match_set, field_to_match.data must be omitted when field_to_match.type is not HEADER."
  }
}