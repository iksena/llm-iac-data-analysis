variable "arn" {
  description = "ARN of the OpenID Connect provider"
  type        = string
  default     = null

  validation {
    condition     = var.arn != null || var.url != null
    error_message = "data_aws_iam_openid_connect_provider, arn: Either 'arn' or 'url' must be specified."
  }
}

variable "url" {
  description = "URL of the OpenID Connect provider"
  type        = string
  default     = null
}