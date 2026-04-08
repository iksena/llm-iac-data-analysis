variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain_id" {
  description = "The ID of the associated Domain."
  type        = string
  validation {
    condition     = can(regex("^d-[a-zA-Z0-9]{10}$", var.domain_id))
    error_message = "resource_aws_sagemaker_space, domain_id must be a valid SageMaker domain ID format (d-xxxxxxxxxx)."
  }
}

variable "space_name" {
  description = "The name of the space."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9\\-])*[a-zA-Z0-9]$", var.space_name)) && length(var.space_name) <= 63
    error_message = "resource_aws_sagemaker_space, space_name must contain only alphanumeric characters and hyphens, cannot start or end with a hyphen, and must be 63 characters or less."
  }
}

variable "space_display_name" {
  description = "The name of the space that appears in the SageMaker AI Studio UI."
  type        = string
  default     = null
}

variable "ownership_settings" {
  description = "A collection of ownership settings. Required if space_sharing_settings is set."
  type = object({
    owner_user_profile_name = string
  })
  default = null
  validation {
    condition = var.ownership_settings == null || (
      var.ownership_settings != null &&
      can(regex("^[a-zA-Z0-9]([a-zA-Z0-9\\-])*[a-zA-Z0-9]$", var.ownership_settings.owner_user_profile_name)) &&
      length(var.ownership_settings.owner_user_profile_name) <= 63
    )
    error_message = "resource_aws_sagemaker_space, ownership_settings.owner_user_profile_name must contain only alphanumeric characters and hyphens, cannot start or end with a hyphen, and must be 63 characters or less."
  }
}

variable "space_settings" {
  description = "A collection of space settings."
  type = object({
    app_type = optional(string)
    code_editor_app_settings = optional(object({
      app_lifecycle_management = optional(object({
        idle_settings = optional(object({
          idle_timeout_in_minutes = optional(number)
        }))
      }))
      default_resource_spec = object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      })
    }))
    custom_file_system = optional(list(object({
      efs_file_system = object({
        file_system_id = string
      })
    })))
    jupyter_lab_app_settings = optional(object({
      app_lifecycle_management = optional(object({
        idle_settings = optional(object({
          idle_timeout_in_minutes = optional(number)
        }))
      }))
      code_repository = optional(list(object({
        repository_url = string
      })))
      default_resource_spec = object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      })
    }))
    jupyter_server_app_settings = optional(object({
      code_repository = optional(list(object({
        repository_url = string
      })))
      default_resource_spec = optional(object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      }))
      lifecycle_config_arns = optional(list(string))
    }))
    kernel_gateway_app_settings = optional(object({
      custom_image = optional(list(object({
        app_image_config_name = string
        image_name            = string
        image_version_number  = optional(number)
      })))
      default_resource_spec = object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      })
      lifecycle_config_arns = optional(list(string))
    }))
    space_storage_settings = optional(object({
      ebs_storage_settings = object({
        ebs_volume_size_in_gb = number
      })
    }))
  })

  validation {
    condition = var.space_settings.code_editor_app_settings == null || (
      var.space_settings.code_editor_app_settings.app_lifecycle_management == null ||
      var.space_settings.code_editor_app_settings.app_lifecycle_management.idle_settings == null ||
      var.space_settings.code_editor_app_settings.app_lifecycle_management.idle_settings.idle_timeout_in_minutes == null ||
      (var.space_settings.code_editor_app_settings.app_lifecycle_management.idle_settings.idle_timeout_in_minutes >= 60 &&
      var.space_settings.code_editor_app_settings.app_lifecycle_management.idle_settings.idle_timeout_in_minutes <= 525600)
    )
    error_message = "resource_aws_sagemaker_space, space_settings.code_editor_app_settings.app_lifecycle_management.idle_settings.idle_timeout_in_minutes must be between 60 and 525600."
  }

  validation {
    condition = var.space_settings.jupyter_lab_app_settings == null || (
      var.space_settings.jupyter_lab_app_settings.app_lifecycle_management == null ||
      var.space_settings.jupyter_lab_app_settings.app_lifecycle_management.idle_settings == null ||
      var.space_settings.jupyter_lab_app_settings.app_lifecycle_management.idle_settings.idle_timeout_in_minutes == null ||
      (var.space_settings.jupyter_lab_app_settings.app_lifecycle_management.idle_settings.idle_timeout_in_minutes >= 60 &&
      var.space_settings.jupyter_lab_app_settings.app_lifecycle_management.idle_settings.idle_timeout_in_minutes <= 525600)
    )
    error_message = "resource_aws_sagemaker_space, space_settings.jupyter_lab_app_settings.app_lifecycle_management.idle_settings.idle_timeout_in_minutes must be between 60 and 525600."
  }

  validation {
    condition = var.space_settings.space_storage_settings == null || (
      var.space_settings.space_storage_settings.ebs_storage_settings.ebs_volume_size_in_gb > 0
    )
    error_message = "resource_aws_sagemaker_space, space_settings.space_storage_settings.ebs_storage_settings.ebs_volume_size_in_gb must be greater than 0."
  }

  validation {
    condition = var.space_settings.kernel_gateway_app_settings == null || (
      var.space_settings.kernel_gateway_app_settings.custom_image == null ||
      alltrue([
        for img in var.space_settings.kernel_gateway_app_settings.custom_image :
        img.image_version_number == null || img.image_version_number > 0
      ])
    )
    error_message = "resource_aws_sagemaker_space, space_settings.kernel_gateway_app_settings.custom_image.image_version_number must be greater than 0 if specified."
  }
}

variable "space_sharing_settings" {
  description = "A collection of space sharing settings. Required if ownership_settings is set."
  type = object({
    sharing_type = string
  })
  default = null
  validation {
    condition = var.space_sharing_settings == null || (
      var.space_sharing_settings != null &&
      contains(["Private", "Shared"], var.space_sharing_settings.sharing_type)
    )
    error_message = "resource_aws_sagemaker_space, space_sharing_settings.sharing_type must be either 'Private' or 'Shared'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}