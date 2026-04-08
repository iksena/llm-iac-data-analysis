variable "repository_name" {
  description = "The name for the repository. This needs to be less than 100 characters."
  type        = string

  validation {
    condition     = length(var.repository_name) <= 100
    error_message = "resource_aws_codecommit_repository, repository_name must be less than or equal to 100 characters."
  }

  validation {
    condition     = length(var.repository_name) > 0
    error_message = "resource_aws_codecommit_repository, repository_name cannot be empty."
  }
}

variable "description" {
  description = "The description of the repository. This needs to be less than 1000 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1000
    error_message = "resource_aws_codecommit_repository, description must be less than or equal to 1000 characters."
  }
}

variable "default_branch" {
  description = "The default branch of the repository. The branch specified here needs to exist."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "The ARN of the encryption key. If no key is specified, the default aws/codecommit Amazon Web Services managed key is used."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}