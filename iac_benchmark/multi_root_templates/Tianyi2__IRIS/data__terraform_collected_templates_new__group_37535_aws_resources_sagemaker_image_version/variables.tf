variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "image_name" {
  description = "The name of the image. Must be unique to your account."
  type        = string

  validation {
    condition     = length(var.image_name) > 0
    error_message = "resource_aws_sagemaker_image_version, image_name cannot be empty."
  }
}

variable "base_image" {
  description = "The registry path of the container image on which this image version is based."
  type        = string

  validation {
    condition     = length(var.base_image) > 0
    error_message = "resource_aws_sagemaker_image_version, base_image cannot be empty."
  }
}

variable "aliases" {
  description = "A list of aliases for the image version."
  type        = list(string)
  default     = null
}

variable "horovod" {
  description = "Indicates Horovod compatibility."
  type        = bool
  default     = null
}

variable "job_type" {
  description = "Indicates SageMaker AI job type compatibility. Valid values are: TRAINING, INFERENCE, and NOTEBOOK_KERNEL."
  type        = string
  default     = null

  validation {
    condition     = var.job_type == null || contains(["TRAINING", "INFERENCE", "NOTEBOOK_KERNEL"], var.job_type)
    error_message = "resource_aws_sagemaker_image_version, job_type must be one of: TRAINING, INFERENCE, NOTEBOOK_KERNEL."
  }
}

variable "ml_framework" {
  description = "The machine learning framework vended in the image version."
  type        = string
  default     = null
}

variable "processor" {
  description = "Indicates CPU or GPU compatibility. Valid values are: CPU and GPU."
  type        = string
  default     = null

  validation {
    condition     = var.processor == null || contains(["CPU", "GPU"], var.processor)
    error_message = "resource_aws_sagemaker_image_version, processor must be one of: CPU, GPU."
  }
}

variable "programming_lang" {
  description = "The supported programming language and its version."
  type        = string
  default     = null
}

variable "release_notes" {
  description = "The maintainer description of the image version."
  type        = string
  default     = null
}

variable "vendor_guidance" {
  description = "The stability of the image version, specified by the maintainer. Valid values are: NOT_PROVIDED, STABLE, TO_BE_ARCHIVED, and ARCHIVED."
  type        = string
  default     = null

  validation {
    condition     = var.vendor_guidance == null || contains(["NOT_PROVIDED", "STABLE", "TO_BE_ARCHIVED", "ARCHIVED"], var.vendor_guidance)
    error_message = "resource_aws_sagemaker_image_version, vendor_guidance must be one of: NOT_PROVIDED, STABLE, TO_BE_ARCHIVED, ARCHIVED."
  }
}