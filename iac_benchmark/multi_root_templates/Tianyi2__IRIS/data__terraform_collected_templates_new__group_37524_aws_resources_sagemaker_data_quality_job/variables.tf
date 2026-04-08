variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the data quality job definition. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "data_quality_app_specification" {
  description = "Specifies the container that runs the monitoring job."
  type = object({
    environment                         = optional(map(string))
    image_uri                           = string
    post_analytics_processor_source_uri = optional(string)
    record_preprocessor_source_uri      = optional(string)
  })

  validation {
    condition     = var.data_quality_app_specification.image_uri != null && var.data_quality_app_specification.image_uri != ""
    error_message = "resource_aws_sagemaker_data_quality_job_definition, data_quality_app_specification.image_uri is required and cannot be empty."
  }
}

variable "data_quality_baseline_config" {
  description = "Configures the constraints and baselines for the monitoring job."
  type = object({
    constraints_resource = optional(object({
      s3_uri = optional(string)
    }))
    statistics_resource = optional(object({
      s3_uri = optional(string)
    }))
  })
  default = null
}

variable "data_quality_job_input" {
  description = "A list of inputs for the monitoring job."
  type = object({
    batch_transform_input = optional(object({
      data_captured_destination_s3_uri = string
      dataset_format = object({
        csv = optional(object({
          header = optional(bool)
        }))
        json = optional(object({
          line = optional(bool)
        }))
      })
      local_path                = optional(string)
      s3_data_distribution_type = optional(string)
      s3_input_mode             = optional(string)
    }))
    endpoint_input = optional(object({
      endpoint_name             = string
      local_path                = optional(string)
      s3_data_distribution_type = optional(string)
      s3_input_mode             = optional(string)
    }))
  })

  validation {
    condition = (
      var.data_quality_job_input.batch_transform_input != null &&
      var.data_quality_job_input.batch_transform_input.data_captured_destination_s3_uri != null &&
      var.data_quality_job_input.batch_transform_input.data_captured_destination_s3_uri != ""
      ) || (
      var.data_quality_job_input.endpoint_input != null &&
      var.data_quality_job_input.endpoint_input.endpoint_name != null &&
      var.data_quality_job_input.endpoint_input.endpoint_name != ""
    )
    error_message = "resource_aws_sagemaker_data_quality_job_definition, data_quality_job_input must have either batch_transform_input.data_captured_destination_s3_uri or endpoint_input.endpoint_name specified."
  }

  validation {
    condition = var.data_quality_job_input.batch_transform_input == null || (
      var.data_quality_job_input.batch_transform_input.s3_data_distribution_type == null ||
      contains(["FullyReplicated", "ShardedByS3Key"], var.data_quality_job_input.batch_transform_input.s3_data_distribution_type)
    )
    error_message = "resource_aws_sagemaker_data_quality_job_definition, data_quality_job_input.batch_transform_input.s3_data_distribution_type must be either 'FullyReplicated' or 'ShardedByS3Key'."
  }

  validation {
    condition = var.data_quality_job_input.batch_transform_input == null || (
      var.data_quality_job_input.batch_transform_input.s3_input_mode == null ||
      contains(["Pipe", "File"], var.data_quality_job_input.batch_transform_input.s3_input_mode)
    )
    error_message = "resource_aws_sagemaker_data_quality_job_definition, data_quality_job_input.batch_transform_input.s3_input_mode must be either 'Pipe' or 'File'."
  }

  validation {
    condition = var.data_quality_job_input.endpoint_input == null || (
      var.data_quality_job_input.endpoint_input.s3_data_distribution_type == null ||
      contains(["FullyReplicated", "ShardedByS3Key"], var.data_quality_job_input.endpoint_input.s3_data_distribution_type)
    )
    error_message = "resource_aws_sagemaker_data_quality_job_definition, data_quality_job_input.endpoint_input.s3_data_distribution_type must be either 'FullyReplicated' or 'ShardedByS3Key'."
  }

  validation {
    condition = var.data_quality_job_input.endpoint_input == null || (
      var.data_quality_job_input.endpoint_input.s3_input_mode == null ||
      contains(["Pipe", "File"], var.data_quality_job_input.endpoint_input.s3_input_mode)
    )
    error_message = "resource_aws_sagemaker_data_quality_job_definition, data_quality_job_input.endpoint_input.s3_input_mode must be either 'Pipe' or 'File'."
  }
}

variable "data_quality_job_output_config" {
  description = "The output configuration for monitoring jobs."
  type = object({
    kms_key_id = optional(string)
    monitoring_outputs = list(object({
      s3_output = object({
        local_path     = optional(string)
        s3_upload_mode = optional(string)
        s3_uri         = string
      })
    }))
  })

  validation {
    condition = length(var.data_quality_job_output_config.monitoring_outputs) > 0 && alltrue([
      for output in var.data_quality_job_output_config.monitoring_outputs :
      output.s3_output.s3_uri != null && output.s3_output.s3_uri != ""
    ])
    error_message = "resource_aws_sagemaker_data_quality_job_definition, data_quality_job_output_config.monitoring_outputs must have at least one output with s3_output.s3_uri specified."
  }

  validation {
    condition = alltrue([
      for output in var.data_quality_job_output_config.monitoring_outputs :
      output.s3_output.s3_upload_mode == null || contains(["Continuous", "EndOfJob"], output.s3_output.s3_upload_mode)
    ])
    error_message = "resource_aws_sagemaker_data_quality_job_definition, data_quality_job_output_config.monitoring_outputs.s3_output.s3_upload_mode must be either 'Continuous' or 'EndOfJob'."
  }
}

variable "job_resources" {
  description = "Identifies the resources to deploy for a monitoring job."
  type = object({
    cluster_config = object({
      instance_count    = number
      instance_type     = string
      volume_kms_key_id = optional(string)
      volume_size_in_gb = number
    })
  })

  validation {
    condition     = var.job_resources.cluster_config.instance_count > 0
    error_message = "resource_aws_sagemaker_data_quality_job_definition, job_resources.cluster_config.instance_count must be greater than 0."
  }

  validation {
    condition     = var.job_resources.cluster_config.instance_type != null && var.job_resources.cluster_config.instance_type != ""
    error_message = "resource_aws_sagemaker_data_quality_job_definition, job_resources.cluster_config.instance_type is required and cannot be empty."
  }

  validation {
    condition     = var.job_resources.cluster_config.volume_size_in_gb > 0
    error_message = "resource_aws_sagemaker_data_quality_job_definition, job_resources.cluster_config.volume_size_in_gb must be greater than 0."
  }
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of an IAM role that Amazon SageMaker AI can assume to perform tasks on your behalf."
  type        = string

  validation {
    condition     = var.role_arn != null && var.role_arn != ""
    error_message = "resource_aws_sagemaker_data_quality_job_definition, role_arn is required and cannot be empty."
  }

  validation {
    condition     = can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_sagemaker_data_quality_job_definition, role_arn must be a valid IAM role ARN."
  }
}

variable "network_config" {
  description = "Specifies networking configuration for the monitoring job."
  type = object({
    enable_inter_container_traffic_encryption = optional(bool)
    enable_network_isolation                  = optional(bool)
    vpc_config = optional(object({
      security_group_ids = list(string)
      subnets            = list(string)
    }))
  })
  default = null

  validation {
    condition = var.network_config == null || var.network_config.vpc_config == null || (
      length(var.network_config.vpc_config.security_group_ids) > 0 &&
      length(var.network_config.vpc_config.subnets) > 0
    )
    error_message = "resource_aws_sagemaker_data_quality_job_definition, network_config.vpc_config.security_group_ids and subnets must be non-empty lists when vpc_config is specified."
  }
}

variable "stopping_condition" {
  description = "A time limit for how long the monitoring job is allowed to run before stopping."
  type = object({
    max_runtime_in_seconds = number
  })
  default = null

  validation {
    condition     = var.stopping_condition == null || var.stopping_condition.max_runtime_in_seconds > 0
    error_message = "resource_aws_sagemaker_data_quality_job_definition, stopping_condition.max_runtime_in_seconds must be greater than 0."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = null
}