variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "profile_name" {
  description = "The name of the profile to initiate the signing operation."
  type        = string

  validation {
    condition     = length(var.profile_name) > 0
    error_message = "resource_aws_signer_signing_job, profile_name must be a non-empty string."
  }
}

variable "source_config" {
  description = "The S3 bucket that contains the object to sign."
  type = object({
    s3 = object({
      bucket  = string
      key     = string
      version = string
    })
  })

  validation {
    condition     = var.source_config.s3 != null
    error_message = "resource_aws_signer_signing_job, source.s3 must be specified."
  }

  validation {
    condition     = length(var.source_config.s3.bucket) > 0
    error_message = "resource_aws_signer_signing_job, source.s3.bucket must be a non-empty string."
  }

  validation {
    condition     = length(var.source_config.s3.key) > 0
    error_message = "resource_aws_signer_signing_job, source.s3.key must be a non-empty string."
  }

  validation {
    condition     = length(var.source_config.s3.version) > 0
    error_message = "resource_aws_signer_signing_job, source.s3.version must be a non-empty string."
  }
}

variable "destination" {
  description = "The S3 bucket in which to save your signed object."
  type = object({
    s3 = object({
      bucket = string
      prefix = optional(string)
    })
  })

  validation {
    condition     = var.destination.s3 != null
    error_message = "resource_aws_signer_signing_job, destination.s3 must be specified."
  }

  validation {
    condition     = length(var.destination.s3.bucket) > 0
    error_message = "resource_aws_signer_signing_job, destination.s3.bucket must be a non-empty string."
  }
}

variable "ignore_signing_job_failure" {
  description = "Set this argument to true to ignore signing job failures and retrieve failed status and reason. Default false."
  type        = bool
  default     = false
}