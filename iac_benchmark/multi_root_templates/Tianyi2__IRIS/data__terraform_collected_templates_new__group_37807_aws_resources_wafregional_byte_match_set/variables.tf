variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name or description of the ByteMatchSet."
  type        = string

  validation {
    condition     = can(regex("^.+$", var.name))
    error_message = "resource_aws_wafregional_byte_match_set, name must be a non-empty string."
  }
}

variable "byte_match_tuples" {
  description = "Settings for the ByteMatchSet, such as the bytes (typically a string that corresponds with ASCII characters) that you want AWS WAF to search for in web requests."
  type = list(object({
    positional_constraint = string
    target_string         = string
    text_transformation   = string
    field_to_match = object({
      data = optional(string)
      type = string
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for tuple in var.byte_match_tuples :
      can(regex("^.+$", tuple.positional_constraint))
    ])
    error_message = "resource_aws_wafregional_byte_match_set, positional_constraint must be a non-empty string for all byte_match_tuples."
  }

  validation {
    condition = alltrue([
      for tuple in var.byte_match_tuples :
      can(regex("^.+$", tuple.target_string)) && length(tuple.target_string) <= 50
    ])
    error_message = "resource_aws_wafregional_byte_match_set, target_string must be a non-empty string with maximum length of 50 bytes for all byte_match_tuples."
  }

  validation {
    condition = alltrue([
      for tuple in var.byte_match_tuples :
      can(regex("^.+$", tuple.text_transformation))
    ])
    error_message = "resource_aws_wafregional_byte_match_set, text_transformation must be a non-empty string for all byte_match_tuples."
  }

  validation {
    condition = alltrue([
      for tuple in var.byte_match_tuples :
      can(regex("^.+$", tuple.field_to_match.type))
    ])
    error_message = "resource_aws_wafregional_byte_match_set, field_to_match.type must be a non-empty string for all byte_match_tuples."
  }
}