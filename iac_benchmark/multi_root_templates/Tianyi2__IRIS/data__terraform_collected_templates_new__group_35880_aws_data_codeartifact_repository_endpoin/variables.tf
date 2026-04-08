variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain" {
  description = "Name of the domain that contains the repository."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9\\-]{0,48}[a-z0-9]$", var.domain)) || can(regex("^[a-z0-9]$", var.domain))
    error_message = "data_aws_codeartifact_repository_endpoint, domain must be between 2-50 characters, start and end with alphanumeric characters, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "repository" {
  description = "Name of the repository."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9._\\-]{0,98}[A-Za-z0-9]$", var.repository)) || can(regex("^[A-Za-z0-9]$", var.repository))
    error_message = "data_aws_codeartifact_repository_endpoint, repository must be between 2-100 characters, start and end with alphanumeric characters, and contain only letters, numbers, dots, underscores, and hyphens."
  }
}

variable "format" {
  description = "Which endpoint of a repository to return. A repository has one endpoint for each package format."
  type        = string

  validation {
    condition     = contains(["npm", "pypi", "maven", "nuget"], var.format)
    error_message = "data_aws_codeartifact_repository_endpoint, format must be one of: npm, pypi, maven, nuget."
  }
}

variable "domain_owner" {
  description = "Account number of the AWS account that owns the domain."
  type        = string
  default     = null

  validation {
    condition     = var.domain_owner == null || can(regex("^[0-9]{12}$", var.domain_owner))
    error_message = "data_aws_codeartifact_repository_endpoint, domain_owner must be a 12-digit AWS account number."
  }
}