variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name or description of the Geo Match Set."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name)) && length(var.name) <= 128
    error_message = "resource_aws_wafregional_geo_match_set, name must be alphanumeric with periods, underscores, or hyphens and cannot exceed 128 characters."
  }
}

variable "geo_match_constraint" {
  description = "The Geo Match Constraint objects which contain the country that you want AWS WAF to search for."
  type = list(object({
    type  = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for constraint in var.geo_match_constraint :
      constraint.type == "Country"
    ])
    error_message = "resource_aws_wafregional_geo_match_set, geo_match_constraint type must be 'Country'."
  }

  validation {
    condition = alltrue([
      for constraint in var.geo_match_constraint :
      can(regex("^[A-Z]{2}$", constraint.value))
    ])
    error_message = "resource_aws_wafregional_geo_match_set, geo_match_constraint value must be a valid two-letter country code (e.g., US, CA, RU, CN)."
  }
}