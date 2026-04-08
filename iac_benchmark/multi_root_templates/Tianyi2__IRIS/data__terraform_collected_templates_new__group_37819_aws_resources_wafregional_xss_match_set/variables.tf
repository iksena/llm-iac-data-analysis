variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the set"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-_]+$", var.name))
    error_message = "resource_aws_wafregional_xss_match_set, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "xss_match_tuples" {
  description = "The parts of web requests that you want to inspect for cross-site scripting attacks"
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
      for tuple in var.xss_match_tuples : contains([
        "NONE", "COMPRESS_WHITE_SPACE", "HTML_ENTITY_DECODE",
        "LOWERCASE", "CMD_LINE", "URL_DECODE"
      ], tuple.text_transformation)
    ])
    error_message = "resource_aws_wafregional_xss_match_set, text_transformation must be one of: NONE, COMPRESS_WHITE_SPACE, HTML_ENTITY_DECODE, LOWERCASE, CMD_LINE, URL_DECODE."
  }

  validation {
    condition = alltrue([
      for tuple in var.xss_match_tuples : contains([
        "URI", "QUERY_STRING", "HEADER", "METHOD", "BODY", "SINGLE_QUERY_ARG", "ALL_QUERY_ARGS"
      ], tuple.field_to_match.type)
    ])
    error_message = "resource_aws_wafregional_xss_match_set, field_to_match.type must be one of: URI, QUERY_STRING, HEADER, METHOD, BODY, SINGLE_QUERY_ARG, ALL_QUERY_ARGS."
  }

  validation {
    condition = alltrue([
      for tuple in var.xss_match_tuples :
      tuple.field_to_match.type == "HEADER" ? tuple.field_to_match.data != null : tuple.field_to_match.data == null
    ])
    error_message = "resource_aws_wafregional_xss_match_set, field_to_match.data is required when type is HEADER and must be omitted for other types."
  }
}