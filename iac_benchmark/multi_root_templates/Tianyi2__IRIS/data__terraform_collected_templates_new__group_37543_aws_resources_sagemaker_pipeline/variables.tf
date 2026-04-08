variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "pipeline_name" {
  description = "The name of the pipeline."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-]{1,256}$", var.pipeline_name))
    error_message = "resource_aws_sagemaker_pipeline, pipeline_name must be between 1 and 256 characters and can only contain alphanumeric characters and hyphens."
  }
}

variable "pipeline_description" {
  description = "A description of the pipeline."
  type        = string
  default     = null

  validation {
    condition     = var.pipeline_description == null || length(var.pipeline_description) <= 3072
    error_message = "resource_aws_sagemaker_pipeline, pipeline_description must be 3072 characters or less."
  }
}

variable "pipeline_display_name" {
  description = "The display name of the pipeline."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-\\s]{1,256}$", var.pipeline_display_name))
    error_message = "resource_aws_sagemaker_pipeline, pipeline_display_name must be between 1 and 256 characters and can only contain alphanumeric characters, hyphens, and spaces."
  }
}

variable "pipeline_definition" {
  description = "The JSON pipeline definition of the pipeline."
  type        = string
  default     = null

  validation {
    condition     = var.pipeline_definition == null || can(jsondecode(var.pipeline_definition))
    error_message = "resource_aws_sagemaker_pipeline, pipeline_definition must be valid JSON."
  }
}

variable "pipeline_definition_s3_location" {
  description = "The location of the pipeline definition stored in Amazon S3."
  type = object({
    bucket     = string
    object_key = string
    version_id = optional(string)
  })
  default = null

  validation {
    condition = var.pipeline_definition_s3_location == null || (
      var.pipeline_definition_s3_location.bucket != null &&
      var.pipeline_definition_s3_location.object_key != null
    )
    error_message = "resource_aws_sagemaker_pipeline, pipeline_definition_s3_location bucket and object_key are required when pipeline_definition_s3_location is specified."
  }
}

variable "role_arn" {
  description = "The ARN of the IAM role the pipeline will execute as."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.*", var.role_arn))
    error_message = "resource_aws_sagemaker_pipeline, role_arn must be a valid IAM role ARN."
  }
}

variable "parallelism_configuration" {
  description = "Configuration that controls the parallelism of the pipeline."
  type = object({
    max_parallel_execution_steps = number
  })
  default = null

  validation {
    condition = var.parallelism_configuration == null || (
      var.parallelism_configuration.max_parallel_execution_steps >= 1 &&
      var.parallelism_configuration.max_parallel_execution_steps <= 256
    )
    error_message = "resource_aws_sagemaker_pipeline, parallelism_configuration max_parallel_execution_steps must be between 1 and 256."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}