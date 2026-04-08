variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name or description of the Size Constraint Set."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_wafregional_size_constraint_set, name must not be empty."
  }
}

variable "size_constraints" {
  description = "Specifies the parts of web requests that you want to inspect the size of."
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
      for constraint in var.size_constraints :
      contains(["EQ", "NE", "LT", "GT", "LE", "GE"], constraint.comparison_operator)
    ])
    error_message = "resource_aws_wafregional_size_constraint_set, comparison_operator must be one of: EQ, NE, LT, GT, LE, GE."
  }

  validation {
    condition = alltrue([
      for constraint in var.size_constraints :
      constraint.size >= 0 && constraint.size <= 21474836480
    ])
    error_message = "resource_aws_wafregional_size_constraint_set, size must be between 0 and 21474836480 bytes (0 - 20 GB)."
  }

  validation {
    condition = alltrue([
      for constraint in var.size_constraints :
      contains(["CMD_LINE", "HTML_ENTITY_DECODE", "NONE", "COMPRESS_WHITE_SPACE", "URL_DECODE", "LOWERCASE"], constraint.text_transformation)
    ])
    error_message = "resource_aws_wafregional_size_constraint_set, text_transformation must be one of: CMD_LINE, HTML_ENTITY_DECODE, NONE, COMPRESS_WHITE_SPACE, URL_DECODE, LOWERCASE."
  }

  validation {
    condition = alltrue([
      for constraint in var.size_constraints :
      contains(["HEADER", "METHOD", "QUERY_STRING", "URI", "BODY", "SINGLE_QUERY_ARG", "ALL_QUERY_ARGS"], constraint.field_to_match.type)
    ])
    error_message = "resource_aws_wafregional_size_constraint_set, field_to_match.type must be one of: HEADER, METHOD, QUERY_STRING, URI, BODY, SINGLE_QUERY_ARG, ALL_QUERY_ARGS."
  }

  validation {
    condition = alltrue([
      for constraint in var.size_constraints :
      constraint.field_to_match.type == "BODY" ? constraint.text_transformation == "NONE" : true
    ])
    error_message = "resource_aws_wafregional_size_constraint_set, text_transformation must be NONE when field_to_match.type is BODY."
  }

  validation {
    condition = alltrue([
      for constraint in var.size_constraints :
      constraint.field_to_match.type == "HEADER" ? constraint.field_to_match.data != null && length(constraint.field_to_match.data) > 0 : true
    ])
    error_message = "resource_aws_wafregional_size_constraint_set, field_to_match.data is required when field_to_match.type is HEADER."
  }
}