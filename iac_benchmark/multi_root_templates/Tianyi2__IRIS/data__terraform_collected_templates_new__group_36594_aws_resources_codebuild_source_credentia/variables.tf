variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "auth_type" {
  description = "The type of authentication used to connect to a GitHub, GitHub Enterprise, or Bitbucket repository."
  type        = string

  validation {
    condition = contains([
      "BASIC_AUTH",
      "PERSONAL_ACCESS_TOKEN",
      "CODECONNECTIONS",
      "SECRETS_MANAGER"
    ], var.auth_type)
    error_message = "resource_aws_codebuild_source_credential, auth_type must be one of: BASIC_AUTH, PERSONAL_ACCESS_TOKEN, CODECONNECTIONS, SECRETS_MANAGER."
  }
}

variable "server_type" {
  description = "The source provider used for this project."
  type        = string
}

variable "token" {
  description = "For a GitHub and GitHub Enterprise, this is the personal access token. For Bitbucket, this is the app password. When using an AWS CodeStar connection (auth_type = \"CODECONNECTIONS\"), this is an AWS CodeStar Connection ARN."
  type        = string
  sensitive   = true
}

variable "user_name" {
  description = "The Bitbucket username when the authType is BASIC_AUTH. This parameter is not valid for other types of source providers or connections."
  type        = string
  default     = null

  validation {
    condition     = var.user_name == null || var.auth_type == "BASIC_AUTH"
    error_message = "resource_aws_codebuild_source_credential, user_name parameter is only valid when auth_type is BASIC_AUTH."
  }
}