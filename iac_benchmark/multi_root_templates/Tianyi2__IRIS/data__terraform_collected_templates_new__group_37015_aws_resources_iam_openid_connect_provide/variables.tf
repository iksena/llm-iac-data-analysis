variable "url" {
  description = "URL of the identity provider, corresponding to the iss claim"
  type        = string

  validation {
    condition     = can(regex("^https://", var.url))
    error_message = "resource_aws_iam_openid_connect_provider, url must be a valid HTTPS URL."
  }
}

variable "client_id_list" {
  description = "List of client IDs (audiences) that identify the application registered with the OpenID Connect provider"
  type        = list(string)

  validation {
    condition     = length(var.client_id_list) > 0
    error_message = "resource_aws_iam_openid_connect_provider, client_id_list must contain at least one client ID."
  }
}

variable "thumbprint_list" {
  description = "List of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s)"
  type        = list(string)
  default     = null

  validation {
    condition = var.thumbprint_list == null ? true : alltrue([
      for thumbprint in var.thumbprint_list : can(regex("^[a-fA-F0-9]{40}$", thumbprint))
    ])
    error_message = "resource_aws_iam_openid_connect_provider, thumbprint_list must contain valid SHA-1 thumbprints (40 hex characters)."
  }
}

variable "tags" {
  description = "Map of resource tags for the IAM OIDC provider"
  type        = map(string)
  default     = null
}