variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "A friendly name of the regular expression pattern set. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "description" {
  description = "A friendly description of the regular expression pattern set."
  type        = string
  default     = null
}

variable "scope" {
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL."
  type        = string

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "resource_aws_wafv2_regex_pattern_set, scope must be either 'CLOUDFRONT' or 'REGIONAL'."
  }
}

variable "regular_expression" {
  description = "One or more blocks of regular expression patterns that you want AWS WAF to search for."
  type = list(object({
    regex_string = string
  }))
  default = []

  validation {
    condition = alltrue([
      for re in var.regular_expression : re.regex_string != null && re.regex_string != ""
    ])
    error_message = "resource_aws_wafv2_regex_pattern_set, regular_expression regex_string must not be null or empty."
  }
}

variable "tags" {
  description = "An array of key:value pairs to associate with the resource."
  type        = map(string)
  default     = {}
}