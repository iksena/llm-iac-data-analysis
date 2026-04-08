variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the connection to be created. The name must be unique in the calling AWS account. Changing name will create a new resource."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_codestarconnections_connection, name must not be empty."
  }
}

variable "provider_type" {
  description = "The name of the external provider where your third-party code repository is configured. Valid values are Bitbucket, GitHub, GitHubEnterpriseServer, GitLab or GitLabSelfManaged. Changing provider_type will create a new resource. Conflicts with host_arn."
  type        = string
  default     = null

  validation {
    condition = var.provider_type == null ? true : contains([
      "Bitbucket",
      "GitHub",
      "GitHubEnterpriseServer",
      "GitLab",
      "GitLabSelfManaged"
    ], var.provider_type)
    error_message = "resource_aws_codestarconnections_connection, provider_type must be one of: Bitbucket, GitHub, GitHubEnterpriseServer, GitLab, or GitLabSelfManaged."
  }
}

variable "host_arn" {
  description = "The Amazon Resource Name (ARN) of the host associated with the connection. Conflicts with provider_type."
  type        = string
  default     = null

  validation {
    condition     = var.host_arn == null ? true : can(regex("^arn:aws:codestar-connections:", var.host_arn))
    error_message = "resource_aws_codestarconnections_connection, host_arn must be a valid ARN starting with 'arn:aws:codestar-connections:'."
  }
}

variable "tags" {
  description = "Map of key-value resource tags to associate with the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}