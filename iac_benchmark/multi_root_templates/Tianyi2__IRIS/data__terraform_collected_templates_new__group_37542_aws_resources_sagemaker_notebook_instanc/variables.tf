variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_sagemaker_notebook_instance_lifecycle_configuration, region must be a valid AWS region format."
  }
}

variable "name" {
  description = "The name of the lifecycle configuration (must be unique). If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || (length(var.name) <= 63 && can(regex("^[a-zA-Z0-9-]+$", var.name)))
    error_message = "resource_aws_sagemaker_notebook_instance_lifecycle_configuration, name must be up to 63 characters and contain only alphanumeric characters and hyphens."
  }
}

variable "on_create" {
  description = "A shell script (base64-encoded) that runs only once when the SageMaker AI Notebook Instance is created."
  type        = string
  default     = null

  validation {
    condition     = var.on_create == null || can(base64decode(var.on_create))
    error_message = "resource_aws_sagemaker_notebook_instance_lifecycle_configuration, on_create must be a valid base64-encoded string."
  }
}

variable "on_start" {
  description = "A shell script (base64-encoded) that runs every time the SageMaker AI Notebook Instance is started including the time it's created."
  type        = string
  default     = null

  validation {
    condition     = var.on_start == null || can(base64decode(var.on_start))
    error_message = "resource_aws_sagemaker_notebook_instance_lifecycle_configuration, on_start must be a valid base64-encoded string."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_sagemaker_notebook_instance_lifecycle_configuration, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}