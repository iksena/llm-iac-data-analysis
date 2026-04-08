variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain" {
  description = "The domain that contains the created repository."
  type        = string

  validation {
    condition     = length(var.domain) > 0
    error_message = "resource_aws_codeartifact_repository, domain must not be empty."
  }
}

variable "repository" {
  description = "The name of the repository to create."
  type        = string

  validation {
    condition     = length(var.repository) > 0
    error_message = "resource_aws_codeartifact_repository, repository must not be empty."
  }
}

variable "domain_owner" {
  description = "The account number of the AWS account that owns the domain."
  type        = string
  default     = null

  validation {
    condition     = var.domain_owner == null || can(regex("^[0-9]{12}$", var.domain_owner))
    error_message = "resource_aws_codeartifact_repository, domain_owner must be a 12-digit AWS account number."
  }
}

variable "description" {
  description = "The description of the repository."
  type        = string
  default     = null
}

variable "upstream" {
  description = "A list of upstream repositories to associate with the repository. The order of the upstream repositories in the list determines their priority order when AWS CodeArtifact looks for a requested package version."
  type = list(object({
    repository_name = string
  }))
  default = null

  validation {
    condition = var.upstream == null || alltrue([
      for upstream in var.upstream : length(upstream.repository_name) > 0
    ])
    error_message = "resource_aws_codeartifact_repository, upstream repository_name must not be empty."
  }
}

variable "external_connections" {
  description = "An array of external connections associated with the repository. Only one external connection can be set per repository."
  type = list(object({
    external_connection_name = string
  }))
  default = null

  validation {
    condition     = var.external_connections == null || length(var.external_connections) <= 1
    error_message = "resource_aws_codeartifact_repository, external_connections can only have one external connection per repository."
  }

  validation {
    condition = var.external_connections == null || alltrue([
      for connection in var.external_connections : length(connection.external_connection_name) > 0
    ])
    error_message = "resource_aws_codeartifact_repository, external_connections external_connection_name must not be empty."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}