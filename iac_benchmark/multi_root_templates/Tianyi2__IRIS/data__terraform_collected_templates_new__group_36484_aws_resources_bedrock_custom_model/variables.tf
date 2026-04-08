variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "base_model_identifier" {
  description = "The Amazon Resource Name (ARN) of the base model."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:bedrock:", var.base_model_identifier))
    error_message = "resource_aws_bedrock_custom_model, base_model_identifier must be a valid Amazon Bedrock base model ARN."
  }
}

variable "custom_model_kms_key_id" {
  description = "The custom model is encrypted at rest using this key. Specify the key ARN."
  type        = string
  default     = null

  validation {
    condition     = var.custom_model_kms_key_id == null || can(regex("^arn:aws:kms:", var.custom_model_kms_key_id))
    error_message = "resource_aws_bedrock_custom_model, custom_model_kms_key_id must be a valid KMS key ARN."
  }
}

variable "custom_model_name" {
  description = "Name for the custom model."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.custom_model_name))
    error_message = "resource_aws_bedrock_custom_model, custom_model_name must contain only alphanumeric characters, dots, underscores, and hyphens."
  }
}

variable "customization_type" {
  description = "The customization type. Valid values: FINE_TUNING, CONTINUED_PRE_TRAINING."
  type        = string
  default     = null

  validation {
    condition     = var.customization_type == null || contains(["FINE_TUNING", "CONTINUED_PRE_TRAINING"], var.customization_type)
    error_message = "resource_aws_bedrock_custom_model, customization_type must be either 'FINE_TUNING' or 'CONTINUED_PRE_TRAINING'."
  }
}

variable "hyperparameters" {
  description = "Parameters related to tuning the model."
  type        = map(string)

  validation {
    condition     = length(var.hyperparameters) > 0
    error_message = "resource_aws_bedrock_custom_model, hyperparameters must contain at least one parameter."
  }
}

variable "job_name" {
  description = "A name for the customization job."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.job_name))
    error_message = "resource_aws_bedrock_custom_model, job_name must contain only alphanumeric characters, dots, underscores, and hyphens."
  }
}

variable "output_data_config" {
  description = "S3 location for the output data."
  type = object({
    s3_uri = string
  })

  validation {
    condition     = can(regex("^s3://", var.output_data_config.s3_uri))
    error_message = "resource_aws_bedrock_custom_model, output_data_config.s3_uri must be a valid S3 URI starting with 's3://'."
  }
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of an IAM role that Bedrock can assume to perform tasks on your behalf."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_bedrock_custom_model, role_arn must be a valid IAM role ARN."
  }
}

variable "tags" {
  description = "A map of tags to assign to the customization job and custom model."
  type        = map(string)
  default     = {}
}

variable "training_data_config" {
  description = "Information about the training dataset."
  type = object({
    s3_uri = string
  })

  validation {
    condition     = can(regex("^s3://", var.training_data_config.s3_uri))
    error_message = "resource_aws_bedrock_custom_model, training_data_config.s3_uri must be a valid S3 URI starting with 's3://'."
  }
}

variable "validation_data_config" {
  description = "Information about the validation dataset."
  type = object({
    validator = object({
      s3_uri = string
    })
  })
  default = null

  validation {
    condition     = var.validation_data_config == null || can(regex("^s3://", var.validation_data_config.validator.s3_uri))
    error_message = "resource_aws_bedrock_custom_model, validation_data_config.validator.s3_uri must be a valid S3 URI starting with 's3://'."
  }
}

variable "vpc_config" {
  description = "Configuration parameters for the private Virtual Private Cloud (VPC) that contains the resources you are using for this job."
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null

  validation {
    condition = var.vpc_config == null || (
      length(var.vpc_config.security_group_ids) > 0 &&
      length(var.vpc_config.subnet_ids) > 0
    )
    error_message = "resource_aws_bedrock_custom_model, vpc_config must have at least one security group ID and one subnet ID."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    delete = optional(string, "120m")
  })
  default = {
    delete = "120m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_bedrock_custom_model, timeouts.delete must be a valid duration (e.g., '120m', '2h')."
  }
}