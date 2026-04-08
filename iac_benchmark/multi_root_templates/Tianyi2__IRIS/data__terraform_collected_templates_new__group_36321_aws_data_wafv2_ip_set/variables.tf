variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the WAFv2 IP Set."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_wafv2_ip_set, name must not be empty."
  }
}

variable "scope" {
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL."
  type        = string

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "data_aws_wafv2_ip_set, scope must be either 'CLOUDFRONT' or 'REGIONAL'."
  }
}