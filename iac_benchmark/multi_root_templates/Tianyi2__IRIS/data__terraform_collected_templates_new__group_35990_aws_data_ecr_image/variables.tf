variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "registry_id" {
  description = "ID of the Registry where the repository resides."
  type        = string
  default     = null
}

variable "repository_name" {
  description = "Name of the ECR Repository."
  type        = string

  validation {
    condition     = length(var.repository_name) > 0
    error_message = "data_aws_ecr_image, repository_name must not be empty."
  }
}

variable "image_digest" {
  description = "Sha256 digest of the image manifest. At least one of image_digest, image_tag, or most_recent must be specified."
  type        = string
  default     = null

  validation {
    condition     = var.image_digest == null || can(regex("^sha256:[a-f0-9]{64}$", var.image_digest))
    error_message = "data_aws_ecr_image, image_digest must be a valid SHA256 digest in format 'sha256:...' or null."
  }
}

variable "image_tag" {
  description = "Tag associated with this image. At least one of image_digest, image_tag, or most_recent must be specified."
  type        = string
  default     = null
}

variable "most_recent" {
  description = "Return the most recently pushed image. At least one of image_digest, image_tag, or most_recent must be specified."
  type        = bool
  default     = null
}

locals {
  image_identifiers = [
    var.image_digest != null ? 1 : 0,
    var.image_tag != null ? 1 : 0,
    var.most_recent != null ? 1 : 0
  ]
  image_identifiers_count = sum(local.image_identifiers)
}

variable "validate_image_identifiers" {
  description = "Internal validation variable - do not set"
  type        = bool
  default     = true

  validation {
    condition     = var.validate_image_identifiers == true ? local.image_identifiers_count >= 1 : true
    error_message = "data_aws_ecr_image, at least one of image_digest, image_tag, or most_recent must be specified."
  }
}