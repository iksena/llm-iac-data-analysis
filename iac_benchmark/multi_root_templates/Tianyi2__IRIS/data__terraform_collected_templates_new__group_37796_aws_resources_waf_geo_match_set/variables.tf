variable "name" {
  description = "The name or description of the GeoMatchSet"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_waf_geo_match_set, name must be a non-empty string."
  }
}

variable "geo_match_constraints" {
  description = "The GeoMatchConstraint objects which contain the country that you want AWS WAF to search for"
  type = list(object({
    type  = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for constraint in var.geo_match_constraints :
      constraint.type == "Country"
    ])
    error_message = "resource_aws_waf_geo_match_set, geo_match_constraints type must be 'Country'."
  }

  validation {
    condition = alltrue([
      for constraint in var.geo_match_constraints :
      length(constraint.value) == 2 && can(regex("^[A-Z]{2}$", constraint.value))
    ])
    error_message = "resource_aws_waf_geo_match_set, geo_match_constraints value must be a two-letter country code (e.g., US, CA, RU, CN)."
  }
}