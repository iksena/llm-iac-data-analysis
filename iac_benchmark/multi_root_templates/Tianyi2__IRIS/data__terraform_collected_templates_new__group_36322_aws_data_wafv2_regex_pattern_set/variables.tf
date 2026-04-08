variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_wafv2_regex_pattern_set, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "name" {
  type        = string
  description = "Name of the WAFv2 Regex Pattern Set."

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_wafv2_regex_pattern_set, name cannot be empty."
  }
}

variable "scope" {
  type        = string
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL."

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "data_aws_wafv2_regex_pattern_set, scope must be either 'CLOUDFRONT' or 'REGIONAL'."
  }
}