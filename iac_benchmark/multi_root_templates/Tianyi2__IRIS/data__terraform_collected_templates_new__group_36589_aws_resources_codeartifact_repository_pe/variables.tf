variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "repository" {
  description = "The name of the repository to set the resource policy on."
  type        = string

  validation {
    condition     = length(var.repository) > 0
    error_message = "resource_aws_codeartifact_repository_permissions_policy, repository must not be empty."
  }
}

variable "domain" {
  description = "The name of the domain on which to set the resource policy."
  type        = string

  validation {
    condition     = length(var.domain) > 0
    error_message = "resource_aws_codeartifact_repository_permissions_policy, domain must not be empty."
  }
}

variable "policy_document" {
  description = "A JSON policy string to be set as the access control resource policy on the provided domain."
  type        = string

  validation {
    condition     = length(var.policy_document) > 0
    error_message = "resource_aws_codeartifact_repository_permissions_policy, policy_document must not be empty."
  }

  validation {
    condition     = can(jsondecode(var.policy_document))
    error_message = "resource_aws_codeartifact_repository_permissions_policy, policy_document must be valid JSON."
  }
}

variable "domain_owner" {
  description = "The account number of the AWS account that owns the domain."
  type        = string
  default     = null

  validation {
    condition     = var.domain_owner == null || can(regex("^[0-9]{12}$", var.domain_owner))
    error_message = "resource_aws_codeartifact_repository_permissions_policy, domain_owner must be a 12-digit AWS account number."
  }
}

variable "policy_revision" {
  description = "The current revision of the resource policy to be set. This revision is used for optimistic locking, which prevents others from overwriting your changes to the domain's resource policy."
  type        = string
  default     = null
}