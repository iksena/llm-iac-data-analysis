variable "domain" {
  description = "The name of the domain on which to set the resource policy"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9\\-]{0,48}[a-zA-Z0-9]$", var.domain))
    error_message = "resource_aws_codeartifact_domain_permissions_policy, domain must be between 2 and 50 characters and can contain lowercase letters, numbers, and hyphens, but cannot start or end with a hyphen."
  }
}

variable "policy_document" {
  description = "A JSON policy string to be set as the access control resource policy on the provided domain"
  type        = string

  validation {
    condition     = can(jsondecode(var.policy_document))
    error_message = "resource_aws_codeartifact_domain_permissions_policy, policy_document must be valid JSON."
  }
}

variable "domain_owner" {
  description = "The account number of the AWS account that owns the domain"
  type        = string
  default     = null

  validation {
    condition     = var.domain_owner == null || can(regex("^[0-9]{12}$", var.domain_owner))
    error_message = "resource_aws_codeartifact_domain_permissions_policy, domain_owner must be a 12-digit AWS account number."
  }
}

variable "policy_revision" {
  description = "The current revision of the resource policy to be set. This revision is used for optimistic locking, which prevents others from overwriting your changes to the domain's resource policy"
  type        = string
  default     = null

  validation {
    condition     = var.policy_revision == null || can(regex("^[a-zA-Z0-9+/=]+$", var.policy_revision))
    error_message = "resource_aws_codeartifact_domain_permissions_policy, policy_revision must be a valid revision string."
  }
}