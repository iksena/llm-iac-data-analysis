variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "aws_kms_key_arn" {
  description = "The AWS Key Management Service (AWS KMS) key that you want to use with this pipeline."
  type        = string
  default     = null
}

variable "input_bucket" {
  description = "The Amazon S3 bucket in which you saved the media files that you want to transcode and the graphics that you want to use as watermarks."
  type        = string

  validation {
    condition     = length(var.input_bucket) > 0
    error_message = "resource_aws_elastictranscoder_pipeline, input_bucket must not be empty."
  }
}

variable "name" {
  description = "The name of the pipeline. Maximum 40 characters. Forces new resource."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) <= 40
    error_message = "resource_aws_elastictranscoder_pipeline, name must not exceed 40 characters."
  }
}

variable "output_bucket" {
  description = "The Amazon S3 bucket in which you want Elastic Transcoder to save the transcoded files."
  type        = string
  default     = null
}

variable "role" {
  description = "The IAM Amazon Resource Name (ARN) for the role that you want Elastic Transcoder to use to transcode jobs for this pipeline."
  type        = string

  validation {
    condition     = length(var.role) > 0
    error_message = "resource_aws_elastictranscoder_pipeline, role must not be empty."
  }

  validation {
    condition     = can(regex("^arn:aws:iam::", var.role))
    error_message = "resource_aws_elastictranscoder_pipeline, role must be a valid IAM ARN."
  }
}

variable "content_config" {
  description = "The ContentConfig object specifies information about the Amazon S3 bucket in which you want Elastic Transcoder to save transcoded files and playlists."
  type = object({
    bucket        = string
    storage_class = string
  })
  default = null

  validation {
    condition = var.content_config == null || (
      var.content_config != null &&
      contains(["Standard", "ReducedRedundancy"], var.content_config.storage_class)
    )
    error_message = "resource_aws_elastictranscoder_pipeline, content_config.storage_class must be either 'Standard' or 'ReducedRedundancy'."
  }
}

variable "content_config_permissions" {
  description = "The permissions for the content_config object."
  type = list(object({
    access       = string
    grantee      = string
    grantee_type = string
  }))
  default = []

  validation {
    condition = alltrue([
      for perm in var.content_config_permissions :
      contains(["Read", "ReadAcp", "WriteAcp", "FullControl"], perm.access)
    ])
    error_message = "resource_aws_elastictranscoder_pipeline, content_config_permissions.access must be one of 'Read', 'ReadAcp', 'WriteAcp', or 'FullControl'."
  }

  validation {
    condition = alltrue([
      for perm in var.content_config_permissions :
      contains(["Canonical", "Email", "Group"], perm.grantee_type)
    ])
    error_message = "resource_aws_elastictranscoder_pipeline, content_config_permissions.grantee_type must be one of 'Canonical', 'Email', or 'Group'."
  }
}

variable "notifications" {
  description = "The Amazon Simple Notification Service (Amazon SNS) topic that you want to notify to report job status."
  type = object({
    completed   = optional(string)
    error       = optional(string)
    progressing = optional(string)
    warning     = optional(string)
  })
  default = null
}

variable "thumbnail_config" {
  description = "The ThumbnailConfig object specifies information about the Amazon S3 bucket in which you want Elastic Transcoder to save thumbnail files."
  type = object({
    bucket        = string
    storage_class = string
  })
  default = null

  validation {
    condition = var.thumbnail_config == null || (
      var.thumbnail_config != null &&
      contains(["Standard", "ReducedRedundancy"], var.thumbnail_config.storage_class)
    )
    error_message = "resource_aws_elastictranscoder_pipeline, thumbnail_config.storage_class must be either 'Standard' or 'ReducedRedundancy'."
  }
}

variable "thumbnail_config_permissions" {
  description = "The permissions for the thumbnail_config object."
  type = list(object({
    access       = string
    grantee      = string
    grantee_type = string
  }))
  default = []

  validation {
    condition = alltrue([
      for perm in var.thumbnail_config_permissions :
      contains(["Read", "ReadAcp", "WriteAcp", "FullControl"], perm.access)
    ])
    error_message = "resource_aws_elastictranscoder_pipeline, thumbnail_config_permissions.access must be one of 'Read', 'ReadAcp', 'WriteAcp', or 'FullControl'."
  }

  validation {
    condition = alltrue([
      for perm in var.thumbnail_config_permissions :
      contains(["Canonical", "Email", "Group"], perm.grantee_type)
    ])
    error_message = "resource_aws_elastictranscoder_pipeline, thumbnail_config_permissions.grantee_type must be one of 'Canonical', 'Email', or 'Group'."
  }
}