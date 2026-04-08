variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "app_name" {
  description = "The name of the app"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-]+$", var.app_name))
    error_message = "resource_aws_sagemaker_app, app_name must contain only alphanumeric characters and hyphens."
  }
}

variable "app_type" {
  description = "The type of app"
  type        = string
  validation {
    condition = contains([
      "JupyterServer",
      "KernelGateway",
      "RStudioServerPro",
      "RSessionGateway",
      "TensorBoard",
      "CodeEditor",
      "JupyterLab",
      "DetailedProfiler",
      "Canvas"
    ], var.app_type)
    error_message = "resource_aws_sagemaker_app, app_type must be one of: JupyterServer, KernelGateway, RStudioServerPro, RSessionGateway, TensorBoard, CodeEditor, JupyterLab, DetailedProfiler, Canvas."
  }
}

variable "domain_id" {
  description = "The domain ID"
  type        = string
  validation {
    condition     = can(regex("^d-[a-zA-Z0-9]{10,}$", var.domain_id))
    error_message = "resource_aws_sagemaker_app, domain_id must be a valid SageMaker domain ID starting with 'd-'."
  }
}

variable "space_name" {
  description = "The name of the space. At least one of user_profile_name or space_name required"
  type        = string
  default     = null
  validation {
    condition     = var.space_name == null || can(regex("^[a-zA-Z0-9\\-]+$", var.space_name))
    error_message = "resource_aws_sagemaker_app, space_name must contain only alphanumeric characters and hyphens when specified."
  }
}

variable "user_profile_name" {
  description = "The user profile name. At least one of user_profile_name or space_name required"
  type        = string
  default     = null
  validation {
    condition     = var.user_profile_name == null || can(regex("^[a-zA-Z0-9\\-]+$", var.user_profile_name))
    error_message = "resource_aws_sagemaker_app, user_profile_name must contain only alphanumeric characters and hyphens when specified."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "resource_spec" {
  description = "The instance type and the Amazon Resource Name (ARN) of the SageMaker AI image created on the instance"
  type = object({
    instance_type                 = optional(string)
    lifecycle_config_arn          = optional(string)
    sagemaker_image_arn           = optional(string)
    sagemaker_image_version_alias = optional(string)
    sagemaker_image_version_arn   = optional(string)
  })
  default = null

  validation {
    condition = var.resource_spec == null || (
      var.resource_spec.lifecycle_config_arn == null ||
      can(regex("^arn:aws:sagemaker:", var.resource_spec.lifecycle_config_arn))
    )
    error_message = "resource_aws_sagemaker_app, resource_spec.lifecycle_config_arn must be a valid SageMaker ARN when specified."
  }

  validation {
    condition = var.resource_spec == null || (
      var.resource_spec.sagemaker_image_arn == null ||
      can(regex("^arn:aws:sagemaker:", var.resource_spec.sagemaker_image_arn))
    )
    error_message = "resource_aws_sagemaker_app, resource_spec.sagemaker_image_arn must be a valid SageMaker ARN when specified."
  }

  validation {
    condition = var.resource_spec == null || (
      var.resource_spec.sagemaker_image_version_arn == null ||
      can(regex("^arn:aws:sagemaker:", var.resource_spec.sagemaker_image_version_arn))
    )
    error_message = "resource_aws_sagemaker_app, resource_spec.sagemaker_image_version_arn must be a valid SageMaker ARN when specified."
  }
}

# Validation to ensure at least one of user_profile_name or space_name is provided
variable "validation_check" {
  description = "Internal validation variable"
  type        = bool
  default     = true
  validation {
    condition     = var.validation_check
    error_message = "resource_aws_sagemaker_app, at least one of user_profile_name or space_name must be specified."
  }
}