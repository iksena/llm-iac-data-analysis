variable "repository_bitbucket" {
  description = "Configuration for Bitbucket repository association"
  type = object({
    connection_arn = string
    name           = string
    owner          = string
  })
  default = null

  validation {
    condition = var.repository_bitbucket == null || (
      var.repository_bitbucket.connection_arn != null &&
      var.repository_bitbucket.name != null &&
      var.repository_bitbucket.owner != null
    )
    error_message = "resource_aws_codegurureviewer_repository_association, repository_bitbucket requires connection_arn, name, and owner when specified."
  }
}

variable "repository_codecommit" {
  description = "Configuration for CodeCommit repository association"
  type = object({
    name = string
  })
  default = null

  validation {
    condition     = var.repository_codecommit == null || var.repository_codecommit.name != null
    error_message = "resource_aws_codegurureviewer_repository_association, repository_codecommit requires name when specified."
  }
}

variable "repository_github_enterprise_server" {
  description = "Configuration for GitHub Enterprise Server repository association"
  type = object({
    connection_arn = string
    name           = string
    owner          = string
  })
  default = null

  validation {
    condition = var.repository_github_enterprise_server == null || (
      var.repository_github_enterprise_server.connection_arn != null &&
      var.repository_github_enterprise_server.name != null &&
      var.repository_github_enterprise_server.owner != null
    )
    error_message = "resource_aws_codegurureviewer_repository_association, repository_github_enterprise_server requires connection_arn, name, and owner when specified."
  }
}

variable "repository_s3_bucket" {
  description = "Configuration for S3 bucket repository association"
  type = object({
    bucket_name = string
    name        = string
  })
  default = null

  validation {
    condition = var.repository_s3_bucket == null || (
      var.repository_s3_bucket.bucket_name != null &&
      var.repository_s3_bucket.name != null
    )
    error_message = "resource_aws_codegurureviewer_repository_association, repository_s3_bucket requires bucket_name and name when specified."
  }

  validation {
    condition     = var.repository_s3_bucket == null || can(regex("^codeguru-reviewer-", var.repository_s3_bucket.bucket_name))
    error_message = "resource_aws_codegurureviewer_repository_association, repository_s3_bucket bucket_name must begin with 'codeguru-reviewer-'."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "kms_key_details" {
  description = "Configuration for KMS key association"
  type = object({
    encryption_option = optional(string)
    kms_key_id        = optional(string)
  })
  default = null

  validation {
    condition = var.kms_key_details == null || (
      var.kms_key_details.encryption_option == null ||
      contains(["AWS_OWNED_CMK", "CUSTOMER_MANAGED_CMK"], var.kms_key_details.encryption_option)
    )
    error_message = "resource_aws_codegurureviewer_repository_association, kms_key_details encryption_option must be either 'AWS_OWNED_CMK' or 'CUSTOMER_MANAGED_CMK'."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operation"
  type        = string
  default     = "60m"
}

variable "timeouts_update" {
  description = "Timeout for update operation"
  type        = string
  default     = "180m"
}

variable "timeouts_delete" {
  description = "Timeout for delete operation"
  type        = string
  default     = "90m"
}