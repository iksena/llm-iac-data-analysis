variable "global_endpoint_token_version" {
  description = "The version of the STS global endpoint token"
  type        = string

  validation {
    condition     = contains(["v1Token", "v2Token"], var.global_endpoint_token_version)
    error_message = "resource_aws_iam_security_token_service_preferences, global_endpoint_token_version must be either 'v1Token' or 'v2Token'."
  }
}