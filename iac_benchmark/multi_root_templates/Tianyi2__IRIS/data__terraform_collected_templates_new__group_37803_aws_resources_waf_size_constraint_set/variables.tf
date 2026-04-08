variable "name" {
  description = "Name or description of the Size Constraint Set"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_waf_size_constraint_set, name cannot be empty."
  }
}

variable "size_constraints" {
  description = "Parts of web requests that you want to inspect the size of"
  type = list(object({
    comparison_operator = string
    size                = number
    text_transformation = string
    field_to_match = object({
      data = optional(string)
      type = string
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for constraint in var.size_constraints : contains(["EQ", "NE", "LT", "LE", "GT", "GE"], constraint.comparison_operator)
    ])
    error_message = "resource_aws_waf_size_constraint_set, comparison_operator must be one of: EQ, NE, LT, LE, GT, GE."
  }

  validation {
    condition = alltrue([
      for constraint in var.size_constraints : constraint.size >= 0 && constraint.size <= 21474836480
    ])
    error_message = "resource_aws_waf_size_constraint_set, size must be between 0 and 21474836480 bytes (0 and 20 GB)."
  }

  validation {
    condition = alltrue([
      for constraint in var.size_constraints : contains([
        "NONE", "COMPRESS_WHITE_SPACE", "HTML_ENTITY_DECODE", "LOWERCASE",
        "CMD_LINE", "URL_DECODE", "BASE64_DECODE", "HEX_DECODE", "MD5", "REPLACE_COMMENTS",
        "ESCAPE_SEQ_DECODE", "SQL_HEX_DECODE", "CSS_DECODE", "JS_DECODE", "NORMALIZE_PATH",
        "NORMALIZE_PATH_WIN", "REMOVE_NULLS", "REPLACE_NULLS", "BASE64_DECODE_EXT",
        "URL_DECODE_UNI", "UTF8_TO_UNICODE"
      ], constraint.text_transformation)
    ])
    error_message = "resource_aws_waf_size_constraint_set, text_transformation must be a valid transformation type."
  }

  validation {
    condition = alltrue([
      for constraint in var.size_constraints : contains([
        "URI", "QUERY_STRING", "HEADER", "METHOD", "BODY", "SINGLE_QUERY_ARG", "ALL_QUERY_ARGS"
      ], constraint.field_to_match.type)
    ])
    error_message = "resource_aws_waf_size_constraint_set, field_to_match.type must be one of: URI, QUERY_STRING, HEADER, METHOD, BODY, SINGLE_QUERY_ARG, ALL_QUERY_ARGS."
  }

  validation {
    condition = alltrue([
      for constraint in var.size_constraints :
      constraint.field_to_match.type != "BODY" || constraint.text_transformation == "NONE"
    ])
    error_message = "resource_aws_waf_size_constraint_set, when field_to_match.type is BODY, text_transformation must be NONE."
  }

  validation {
    condition = alltrue([
      for constraint in var.size_constraints :
      constraint.field_to_match.type != "HEADER" || constraint.field_to_match.data != null
    ])
    error_message = "resource_aws_waf_size_constraint_set, when field_to_match.type is HEADER, field_to_match.data must be specified."
  }
}