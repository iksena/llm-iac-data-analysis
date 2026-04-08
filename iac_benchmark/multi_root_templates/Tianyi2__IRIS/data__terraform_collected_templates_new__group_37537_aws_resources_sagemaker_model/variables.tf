variable "region" {
  type        = string
  description = "Region where this resource will be managed"
  default     = null
}

variable "name" {
  type        = string
  description = "The name of the model (must be unique). If omitted, Terraform will assign a random, unique name"
  default     = null
}

variable "execution_role_arn" {
  type        = string
  description = "A role that SageMaker AI can assume to access model artifacts and docker images for deployment"

  validation {
    condition     = can(regex("^arn:aws:iam::", var.execution_role_arn))
    error_message = "resource_aws_sagemaker_model, execution_role_arn must be a valid IAM role ARN."
  }
}

variable "primary_container" {
  type = object({
    image                        = optional(string)
    mode                         = optional(string, "SingleModel")
    model_data_url               = optional(string)
    model_package_name           = optional(string)
    container_hostname           = optional(string)
    environment                  = optional(map(string))
    inference_specification_name = optional(string)
    model_data_source = optional(object({
      s3_data_source = object({
        compression_type = string
        s3_data_type     = string
        s3_uri           = string
        model_access_config = optional(object({
          accept_eula = bool
        }))
      })
    }))
    image_config = optional(object({
      repository_access_mode = string
      repository_auth_config = optional(object({
        repository_credentials_provider_arn = string
      }))
    }))
    multi_model_config = optional(object({
      model_cache_setting = optional(string)
    }))
  })
  description = "The primary docker image containing inference code that is used when the model is deployed for predictions"
  default     = null

  validation {
    condition = var.primary_container == null || (
      var.primary_container.mode == null ||
      contains(["SingleModel", "MultiModel"], var.primary_container.mode)
    )
    error_message = "resource_aws_sagemaker_model, primary_container mode must be either 'SingleModel' or 'MultiModel'."
  }

  validation {
    condition = var.primary_container == null || var.primary_container.model_data_source == null || (
      contains(["None", "Gzip"], var.primary_container.model_data_source.s3_data_source.compression_type)
    )
    error_message = "resource_aws_sagemaker_model, primary_container model_data_source compression_type must be either 'None' or 'Gzip'."
  }

  validation {
    condition = var.primary_container == null || var.primary_container.model_data_source == null || (
      contains(["S3Object", "S3Prefix"], var.primary_container.model_data_source.s3_data_source.s3_data_type)
    )
    error_message = "resource_aws_sagemaker_model, primary_container model_data_source s3_data_type must be either 'S3Object' or 'S3Prefix'."
  }

  validation {
    condition = var.primary_container == null || var.primary_container.image_config == null || (
      contains(["Platform", "Vpc"], var.primary_container.image_config.repository_access_mode)
    )
    error_message = "resource_aws_sagemaker_model, primary_container image_config repository_access_mode must be either 'Platform' or 'Vpc'."
  }

  validation {
    condition = var.primary_container == null || var.primary_container.multi_model_config == null || var.primary_container.multi_model_config.model_cache_setting == null || (
      contains(["Enabled", "Disabled"], var.primary_container.multi_model_config.model_cache_setting)
    )
    error_message = "resource_aws_sagemaker_model, primary_container multi_model_config model_cache_setting must be either 'Enabled' or 'Disabled'."
  }
}

variable "container" {
  type = list(object({
    image                        = optional(string)
    mode                         = optional(string, "SingleModel")
    model_data_url               = optional(string)
    model_package_name           = optional(string)
    container_hostname           = optional(string)
    environment                  = optional(map(string))
    inference_specification_name = optional(string)
    model_data_source = optional(object({
      s3_data_source = object({
        compression_type = string
        s3_data_type     = string
        s3_uri           = string
        model_access_config = optional(object({
          accept_eula = bool
        }))
      })
    }))
    image_config = optional(object({
      repository_access_mode = string
      repository_auth_config = optional(object({
        repository_credentials_provider_arn = string
      }))
    }))
    multi_model_config = optional(object({
      model_cache_setting = optional(string)
    }))
  }))
  description = "Specifies containers in the inference pipeline. If not specified, the primary_container argument is required"
  default     = null

  validation {
    condition = var.container == null || alltrue([
      for c in var.container : c.mode == null || contains(["SingleModel", "MultiModel"], c.mode)
    ])
    error_message = "resource_aws_sagemaker_model, container mode must be either 'SingleModel' or 'MultiModel'."
  }

  validation {
    condition = var.container == null || alltrue([
      for c in var.container : c.model_data_source == null || contains(["None", "Gzip"], c.model_data_source.s3_data_source.compression_type)
    ])
    error_message = "resource_aws_sagemaker_model, container model_data_source compression_type must be either 'None' or 'Gzip'."
  }

  validation {
    condition = var.container == null || alltrue([
      for c in var.container : c.model_data_source == null || contains(["S3Object", "S3Prefix"], c.model_data_source.s3_data_source.s3_data_type)
    ])
    error_message = "resource_aws_sagemaker_model, container model_data_source s3_data_type must be either 'S3Object' or 'S3Prefix'."
  }

  validation {
    condition = var.container == null || alltrue([
      for c in var.container : c.image_config == null || contains(["Platform", "Vpc"], c.image_config.repository_access_mode)
    ])
    error_message = "resource_aws_sagemaker_model, container image_config repository_access_mode must be either 'Platform' or 'Vpc'."
  }

  validation {
    condition = var.container == null || alltrue([
      for c in var.container : c.multi_model_config == null || c.multi_model_config.model_cache_setting == null || contains(["Enabled", "Disabled"], c.multi_model_config.model_cache_setting)
    ])
    error_message = "resource_aws_sagemaker_model, container multi_model_config model_cache_setting must be either 'Enabled' or 'Disabled'."
  }
}

variable "inference_execution_config" {
  type = object({
    mode = string
  })
  description = "Specifies details of how containers in a multi-container endpoint are called"
  default     = null

  validation {
    condition = var.inference_execution_config == null || (
      contains(["Serial", "Direct"], var.inference_execution_config.mode)
    )
    error_message = "resource_aws_sagemaker_model, inference_execution_config mode must be either 'Serial' or 'Direct'."
  }
}

variable "enable_network_isolation" {
  type        = bool
  description = "Isolates the model container. No inbound or outbound network calls can be made to or from the model container"
  default     = null
}

variable "vpc_config" {
  type = object({
    security_group_ids = list(string)
    subnets            = list(string)
  })
  description = "Specifies the VPC that you want your model to connect to. VpcConfig is used in hosting services and in batch transform"
  default     = null

  validation {
    condition = var.vpc_config == null || (
      length(var.vpc_config.security_group_ids) > 0 && length(var.vpc_config.subnets) > 0
    )
    error_message = "resource_aws_sagemaker_model, vpc_config must have at least one security_group_id and one subnet."
  }
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource"
  default     = {}
}