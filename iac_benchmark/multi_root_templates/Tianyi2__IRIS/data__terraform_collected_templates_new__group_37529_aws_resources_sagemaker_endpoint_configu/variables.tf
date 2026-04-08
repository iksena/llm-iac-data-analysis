variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "production_variants" {
  description = "A list of ProductionVariant objects, one for each model that you want to host at this endpoint."
  type = list(object({
    accelerator_type                                  = optional(string)
    container_startup_health_check_timeout_in_seconds = optional(number)
    core_dump_config = optional(object({
      destination_s3_uri = string
      kms_key_id         = string
    }))
    enable_ssm_access                      = optional(bool)
    inference_ami_version                  = optional(string)
    initial_instance_count                 = optional(number)
    instance_type                          = optional(string)
    initial_variant_weight                 = optional(number)
    model_data_download_timeout_in_seconds = optional(number)
    model_name                             = string
    routing_config = optional(object({
      routing_strategy = string
    }))
    serverless_config = optional(object({
      max_concurrency         = number
      memory_size_in_mb       = number
      provisioned_concurrency = optional(number)
    }))
    managed_instance_scaling = optional(object({
      status             = optional(string)
      min_instance_count = optional(number)
      max_instance_count = optional(number)
    }))
    variant_name      = optional(string)
    volume_size_in_gb = optional(number)
  }))

  validation {
    condition = alltrue([
      for variant in var.production_variants :
      variant.container_startup_health_check_timeout_in_seconds == null ||
      (variant.container_startup_health_check_timeout_in_seconds >= 60 &&
      variant.container_startup_health_check_timeout_in_seconds <= 3600)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, container_startup_health_check_timeout_in_seconds must be between 60 and 3600 seconds."
  }

  validation {
    condition = alltrue([
      for variant in var.production_variants :
      variant.model_data_download_timeout_in_seconds == null ||
      (variant.model_data_download_timeout_in_seconds >= 60 &&
      variant.model_data_download_timeout_in_seconds <= 3600)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, model_data_download_timeout_in_seconds must be between 60 and 3600 seconds."
  }

  validation {
    condition = alltrue([
      for variant in var.production_variants :
      variant.volume_size_in_gb == null ||
      (variant.volume_size_in_gb >= 1 && variant.volume_size_in_gb <= 512)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, volume_size_in_gb must be between 1 and 512 GB."
  }

  validation {
    condition = alltrue([
      for variant in var.production_variants :
      variant.routing_config == null ||
      contains(["LEAST_OUTSTANDING_REQUESTS", "RANDOM"], variant.routing_config.routing_strategy)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, routing_strategy must be either 'LEAST_OUTSTANDING_REQUESTS' or 'RANDOM'."
  }

  validation {
    condition = alltrue([
      for variant in var.production_variants :
      variant.serverless_config == null ||
      (variant.serverless_config.max_concurrency >= 1 && variant.serverless_config.max_concurrency <= 200)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, max_concurrency must be between 1 and 200."
  }

  validation {
    condition = alltrue([
      for variant in var.production_variants :
      variant.serverless_config == null ||
      contains([1024, 2048, 3072, 4096, 5120, 6144], variant.serverless_config.memory_size_in_mb)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, memory_size_in_mb must be one of: 1024, 2048, 3072, 4096, 5120, or 6144 MB."
  }

  validation {
    condition = alltrue([
      for variant in var.production_variants :
      variant.serverless_config == null ||
      variant.serverless_config.provisioned_concurrency == null ||
      (variant.serverless_config.provisioned_concurrency >= 1 &&
        variant.serverless_config.provisioned_concurrency <= 200 &&
      variant.serverless_config.provisioned_concurrency <= variant.serverless_config.max_concurrency)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, provisioned_concurrency must be between 1 and 200 and less than or equal to max_concurrency."
  }

  validation {
    condition = alltrue([
      for variant in var.production_variants :
      variant.managed_instance_scaling == null ||
      variant.managed_instance_scaling.status == null ||
      contains(["ENABLED", "DISABLED"], variant.managed_instance_scaling.status)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, managed_instance_scaling status must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "shadow_production_variants" {
  description = "Array of ProductionVariant objects. There is one for each model that you want to host at this endpoint in shadow mode with production traffic replicated from the model specified on ProductionVariants."
  type = list(object({
    accelerator_type                                  = optional(string)
    container_startup_health_check_timeout_in_seconds = optional(number)
    core_dump_config = optional(object({
      destination_s3_uri = string
      kms_key_id         = string
    }))
    enable_ssm_access                      = optional(bool)
    inference_ami_version                  = optional(string)
    initial_instance_count                 = optional(number)
    instance_type                          = optional(string)
    initial_variant_weight                 = optional(number)
    model_data_download_timeout_in_seconds = optional(number)
    model_name                             = string
    routing_config = optional(object({
      routing_strategy = string
    }))
    serverless_config = optional(object({
      max_concurrency         = number
      memory_size_in_mb       = number
      provisioned_concurrency = optional(number)
    }))
    managed_instance_scaling = optional(object({
      status             = optional(string)
      min_instance_count = optional(number)
      max_instance_count = optional(number)
    }))
    variant_name      = optional(string)
    volume_size_in_gb = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for variant in var.shadow_production_variants :
      variant.container_startup_health_check_timeout_in_seconds == null ||
      (variant.container_startup_health_check_timeout_in_seconds >= 60 &&
      variant.container_startup_health_check_timeout_in_seconds <= 3600)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, container_startup_health_check_timeout_in_seconds must be between 60 and 3600 seconds."
  }

  validation {
    condition = alltrue([
      for variant in var.shadow_production_variants :
      variant.model_data_download_timeout_in_seconds == null ||
      (variant.model_data_download_timeout_in_seconds >= 60 &&
      variant.model_data_download_timeout_in_seconds <= 3600)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, model_data_download_timeout_in_seconds must be between 60 and 3600 seconds."
  }

  validation {
    condition = alltrue([
      for variant in var.shadow_production_variants :
      variant.volume_size_in_gb == null ||
      (variant.volume_size_in_gb >= 1 && variant.volume_size_in_gb <= 512)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, volume_size_in_gb must be between 1 and 512 GB."
  }

  validation {
    condition = alltrue([
      for variant in var.shadow_production_variants :
      variant.routing_config == null ||
      contains(["LEAST_OUTSTANDING_REQUESTS", "RANDOM"], variant.routing_config.routing_strategy)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, routing_strategy must be either 'LEAST_OUTSTANDING_REQUESTS' or 'RANDOM'."
  }

  validation {
    condition = alltrue([
      for variant in var.shadow_production_variants :
      variant.serverless_config == null ||
      (variant.serverless_config.max_concurrency >= 1 && variant.serverless_config.max_concurrency <= 200)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, max_concurrency must be between 1 and 200."
  }

  validation {
    condition = alltrue([
      for variant in var.shadow_production_variants :
      variant.serverless_config == null ||
      contains([1024, 2048, 3072, 4096, 5120, 6144], variant.serverless_config.memory_size_in_mb)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, memory_size_in_mb must be one of: 1024, 2048, 3072, 4096, 5120, or 6144 MB."
  }

  validation {
    condition = alltrue([
      for variant in var.shadow_production_variants :
      variant.serverless_config == null ||
      variant.serverless_config.provisioned_concurrency == null ||
      (variant.serverless_config.provisioned_concurrency >= 1 &&
        variant.serverless_config.provisioned_concurrency <= 200 &&
      variant.serverless_config.provisioned_concurrency <= variant.serverless_config.max_concurrency)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, provisioned_concurrency must be between 1 and 200 and less than or equal to max_concurrency."
  }

  validation {
    condition = alltrue([
      for variant in var.shadow_production_variants :
      variant.managed_instance_scaling == null ||
      variant.managed_instance_scaling.status == null ||
      contains(["ENABLED", "DISABLED"], variant.managed_instance_scaling.status)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, managed_instance_scaling status must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "kms_key_arn" {
  description = "Amazon Resource Name (ARN) of a AWS Key Management Service key that Amazon SageMaker AI uses to encrypt data on the storage volume attached to the ML compute instance that hosts the endpoint."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the endpoint configuration. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique endpoint configuration name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "data_capture_config" {
  description = "Specifies the parameters to capture input/output of SageMaker AI models endpoints."
  type = object({
    initial_sampling_percentage = number
    destination_s3_uri          = string
    kms_key_id                  = optional(string)
    enable_capture              = optional(bool)
    capture_options = list(object({
      capture_mode = string
    }))
    capture_content_type_header = optional(object({
      csv_content_types  = optional(list(string))
      json_content_types = optional(list(string))
    }))
  })
  default = null

  validation {
    condition = var.data_capture_config == null || (
      var.data_capture_config.initial_sampling_percentage >= 0 &&
      var.data_capture_config.initial_sampling_percentage <= 100
    )
    error_message = "resource_aws_sagemaker_endpoint_configuration, initial_sampling_percentage must be between 0 and 100."
  }

  validation {
    condition = var.data_capture_config == null || alltrue([
      for option in var.data_capture_config.capture_options :
      contains(["Input", "Output", "InputAndOutput"], option.capture_mode)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, capture_mode must be one of: Input, Output, or InputAndOutput."
  }

  validation {
    condition = var.data_capture_config == null || var.data_capture_config.capture_content_type_header == null || (
      var.data_capture_config.capture_content_type_header.csv_content_types != null ||
      var.data_capture_config.capture_content_type_header.json_content_types != null
    )
    error_message = "resource_aws_sagemaker_endpoint_configuration, either csv_content_types or json_content_types is required in capture_content_type_header."
  }
}

variable "async_inference_config" {
  description = "Specifies configuration for how an endpoint performs asynchronous inference."
  type = object({
    output_config = object({
      s3_output_path  = string
      s3_failure_path = optional(string)
      kms_key_id      = optional(string)
      notification_config = optional(object({
        include_inference_response_in = optional(list(string))
        error_topic                   = optional(string)
        success_topic                 = optional(string)
      }))
    })
    client_config = optional(object({
      max_concurrent_invocations_per_instance = optional(number)
    }))
  })
  default = null

  validation {
    condition = var.async_inference_config == null || var.async_inference_config.output_config.notification_config == null || var.async_inference_config.output_config.notification_config.include_inference_response_in == null || alltrue([
      for response_type in var.async_inference_config.output_config.notification_config.include_inference_response_in :
      contains(["SUCCESS_NOTIFICATION_TOPIC", "ERROR_NOTIFICATION_TOPIC"], response_type)
    ])
    error_message = "resource_aws_sagemaker_endpoint_configuration, include_inference_response_in must contain only 'SUCCESS_NOTIFICATION_TOPIC' and/or 'ERROR_NOTIFICATION_TOPIC'."
  }
}