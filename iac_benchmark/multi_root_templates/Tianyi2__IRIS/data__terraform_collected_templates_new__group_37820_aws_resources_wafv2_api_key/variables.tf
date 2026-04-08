variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "scope" {
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL."
  type        = string

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "resource_aws_wafv2_api_key, scope must be either 'CLOUDFRONT' or 'REGIONAL'."
  }
}

variable "token_domains" {
  description = "The domains that you want to be able to use the API key with. You can specify up to 5 domains."
  type        = list(string)

  validation {
    condition     = length(var.token_domains) >= 1 && length(var.token_domains) <= 5
    error_message = "resource_aws_wafv2_api_key, token_domains must contain between 1 and 5 domains."
  }
}