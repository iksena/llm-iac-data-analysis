variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "device_fleet_name" {
  description = "The name of the Device Fleet (must be unique)."
  type        = string

  validation {
    condition     = length(var.device_fleet_name) > 0
    error_message = "resource_aws_sagemaker_device_fleet, device_fleet_name must not be empty."
  }
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) that has access to AWS Internet of Things (IoT)."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_sagemaker_device_fleet, role_arn must be a valid IAM role ARN."
  }
}

variable "output_config" {
  description = "Specifies details about the repository."
  type = object({
    s3_output_location = string
    kms_key_id         = optional(string)
  })

  validation {
    condition     = can(regex("^s3://[a-z0-9.-]+/.+", var.output_config.s3_output_location))
    error_message = "resource_aws_sagemaker_device_fleet, output_config.s3_output_location must be a valid S3 URI starting with 's3://'."
  }

  validation {
    condition     = var.output_config.kms_key_id == null || can(regex("^(arn:aws[a-zA-Z-]*:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+|alias/.+|[a-f0-9-]+)$", var.output_config.kms_key_id))
    error_message = "resource_aws_sagemaker_device_fleet, output_config.kms_key_id must be a valid KMS key ID, ARN, or alias."
  }
}

variable "description" {
  description = "A description of the fleet."
  type        = string
  default     = null
}

variable "enable_iot_role_alias" {
  description = "Whether to create an AWS IoT Role Alias during device fleet creation. The name of the role alias generated will match this pattern: 'SageMakerEdge-{DeviceFleetName}'."
  type        = bool
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}