variable "layer_name" {
  description = "Unique name for your Lambda Layer"
  type        = string
}

variable "compatible_architectures" {
  description = "List of Architectures this layer is compatible with. Currently x86_64 and arm64 can be specified"
  type        = list(string)
  default     = null

  validation {
    condition = var.compatible_architectures == null ? true : alltrue([
      for arch in var.compatible_architectures : contains(["x86_64", "arm64"], arch)
    ])
    error_message = "resource_aws_lambda_layer_version, compatible_architectures must contain only 'x86_64' and/or 'arm64'."
  }
}

variable "compatible_runtimes" {
  description = "List of Runtimes this layer is compatible with. Up to 15 runtimes can be specified"
  type        = list(string)
  default     = null

  validation {
    condition     = var.compatible_runtimes == null ? true : length(var.compatible_runtimes) <= 15
    error_message = "resource_aws_lambda_layer_version, compatible_runtimes can specify up to 15 runtimes."
  }
}

variable "description" {
  description = "Description of what your Lambda Layer does"
  type        = string
  default     = null
}

variable "filename" {
  description = "Path to the function's deployment package within the local filesystem. If defined, The s3_-prefixed options cannot be used"
  type        = string
  default     = null
}

variable "license_info" {
  description = "License info for your Lambda Layer"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket location containing the function's deployment package. Conflicts with filename. This bucket must reside in the same AWS region where you are creating the Lambda function"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of an object containing the function's deployment package. Conflicts with filename"
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "Object version containing the function's deployment package. Conflicts with filename"
  type        = string
  default     = null
}

variable "skip_destroy" {
  description = "Whether to retain the old version of a previously deployed Lambda Layer. Default is false. When this is not set to true, changing any of compatible_architectures, compatible_runtimes, description, filename, layer_name, license_info, s3_bucket, s3_key, s3_object_version, or source_code_hash forces deletion of the existing layer version and creation of a new layer version"
  type        = bool
  default     = false
}

variable "source_code_hash" {
  description = "Virtual attribute used to trigger replacement when source code changes. Must be set to a base64-encoded SHA256 hash of the package file specified with either filename or s3_key. The usual way to set this is filebase64sha256(\"file.zip\") (Terraform 0.11.12 or later) or base64sha256(file(\"file.zip\")) (Terraform 0.11.11 and earlier), where \"file.zip\" is the local filename of the lambda layer source archive"
  type        = string
  default     = null
}