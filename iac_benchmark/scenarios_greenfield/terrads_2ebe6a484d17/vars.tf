variable "inherited_tags" {
  type        = map(any)
  description = "Tags that are handed down by the parent module"
  default     = { Environment = "benchmark" }
}

variable "github_oidc_arn" {
  type        = string
  description = "Github OpenID Connect ARN"
  default     = "arn:aws:iam::614084726772:oidc-provider/token.actions.githubusercontent.com"
}

variable "referer_value" {
  type        = string
  description = "Referer value used between cloudfront and s3"
  sensitive   = true
  default     = "benchmark-referer-secret"
}
