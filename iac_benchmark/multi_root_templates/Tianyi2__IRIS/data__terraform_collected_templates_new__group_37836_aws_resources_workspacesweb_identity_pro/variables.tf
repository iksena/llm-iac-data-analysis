variable "identity_provider_details" {
  description = "Identity provider details. The keys required depend on the identity provider type."
  type        = map(string)

  validation {
    condition     = length(var.identity_provider_details) > 0
    error_message = "resource_aws_workspacesweb_identity_provider, identity_provider_details must not be empty."
  }
}

variable "identity_provider_name" {
  description = "Identity provider name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.identity_provider_name)) && length(var.identity_provider_name) > 0
    error_message = "resource_aws_workspacesweb_identity_provider, identity_provider_name must be a non-empty string containing only alphanumeric characters, dots, underscores, and hyphens."
  }
}

variable "identity_provider_type" {
  description = "Identity provider type."
  type        = string

  validation {
    condition     = contains(["SAML", "Facebook", "Google", "LoginWithAmazon", "SignInWithApple", "OIDC"], var.identity_provider_type)
    error_message = "resource_aws_workspacesweb_identity_provider, identity_provider_type must be one of: SAML, Facebook, Google, LoginWithAmazon, SignInWithApple, OIDC."
  }
}

variable "portal_arn" {
  description = "ARN of the web portal."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:", var.portal_arn))
    error_message = "resource_aws_workspacesweb_identity_provider, portal_arn must be a valid WorkSpaces Web portal ARN starting with 'arn:aws:workspaces-web:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]+-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_workspacesweb_identity_provider, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_workspacesweb_identity_provider, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}