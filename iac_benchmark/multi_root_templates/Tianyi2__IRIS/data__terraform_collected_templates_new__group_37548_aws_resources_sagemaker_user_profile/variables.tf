variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain_id" {
  description = "The ID of the associated Domain."
  type        = string
  validation {
    condition     = var.domain_id != null && var.domain_id != ""
    error_message = "resource_aws_sagemaker_user_profile, domain_id must be provided and cannot be empty."
  }
}

variable "single_sign_on_user_identifier" {
  description = "A specifier for the type of value specified in single_sign_on_user_value. Currently, the only supported value is UserName. If the Domain's AuthMode is SSO, this field is required. If the Domain's AuthMode is not SSO, this field cannot be specified."
  type        = string
  default     = null
  validation {
    condition     = var.single_sign_on_user_identifier == null || contains(["UserName"], var.single_sign_on_user_identifier)
    error_message = "resource_aws_sagemaker_user_profile, single_sign_on_user_identifier must be 'UserName' when specified."
  }
}

variable "single_sign_on_user_value" {
  description = "The username of the associated AWS Single Sign-On User for this User Profile. If the Domain's AuthMode is SSO, this field is required, and must match a valid username of a user in your directory. If the Domain's AuthMode is not SSO, this field cannot be specified."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "user_profile_name" {
  description = "The name for the User Profile."
  type        = string
  validation {
    condition     = var.user_profile_name != null && var.user_profile_name != ""
    error_message = "resource_aws_sagemaker_user_profile, user_profile_name must be provided and cannot be empty."
  }
}

variable "user_settings_auto_mount_home_efs" {
  description = "Indicates whether auto-mounting of an EFS volume is supported for the user profile. The DefaultAsDomain value is only supported for user profiles. Do not use the DefaultAsDomain value when setting this parameter for a domain. Valid values are: Enabled, Disabled, and DefaultAsDomain."
  type        = string
  default     = null
  validation {
    condition     = var.user_settings_auto_mount_home_efs == null || contains(["Enabled", "Disabled", "DefaultAsDomain"], var.user_settings_auto_mount_home_efs)
    error_message = "resource_aws_sagemaker_user_profile, user_settings_auto_mount_home_efs must be one of: Enabled, Disabled, DefaultAsDomain."
  }
}

variable "user_settings_canvas_app_settings" {
  description = "The Canvas app settings."
  type = object({
    direct_deploy_settings = optional(object({
      status = optional(string)
    }))
    identity_provider_oauth_settings = optional(list(object({
      data_source_name = optional(string)
      secret_arn       = optional(string)
      status           = optional(string)
    })))
    emr_serverless_settings = optional(object({
      execution_role_arn = optional(string)
      status             = optional(string)
    }))
    kendra_settings = optional(object({
      status = optional(string)
    }))
    model_register_settings = optional(object({
      cross_account_model_register_role_arn = optional(string)
      status                                = optional(string)
    }))
    time_series_forecasting_settings = optional(object({
      amazon_forecast_role_arn = optional(string)
      status                   = optional(string)
    }))
    workspace_settings = optional(object({
      s3_artifact_path = optional(string)
      s3_kms_key_id    = optional(string)
    }))
  })
  default = null
  validation {
    condition = var.user_settings_canvas_app_settings == null || (
      var.user_settings_canvas_app_settings.direct_deploy_settings == null ||
      var.user_settings_canvas_app_settings.direct_deploy_settings.status == null ||
      contains(["ENABLED", "DISABLED"], var.user_settings_canvas_app_settings.direct_deploy_settings.status)
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_canvas_app_settings.direct_deploy_settings.status must be one of: ENABLED, DISABLED."
  }
  validation {
    condition = var.user_settings_canvas_app_settings == null || (
      var.user_settings_canvas_app_settings.identity_provider_oauth_settings == null ||
      alltrue([
        for oauth in var.user_settings_canvas_app_settings.identity_provider_oauth_settings : (
          oauth.data_source_name == null || contains(["SalesforceGenie", "Snowflake"], oauth.data_source_name)
          ) && (
          oauth.status == null || contains(["ENABLED", "DISABLED"], oauth.status)
        )
      ])
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_canvas_app_settings.identity_provider_oauth_settings data_source_name must be SalesforceGenie or Snowflake, status must be ENABLED or DISABLED."
  }
  validation {
    condition = var.user_settings_canvas_app_settings == null || (
      var.user_settings_canvas_app_settings.emr_serverless_settings == null ||
      var.user_settings_canvas_app_settings.emr_serverless_settings.status == null ||
      contains(["ENABLED", "DISABLED"], var.user_settings_canvas_app_settings.emr_serverless_settings.status)
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_canvas_app_settings.emr_serverless_settings.status must be one of: ENABLED, DISABLED."
  }
  validation {
    condition = var.user_settings_canvas_app_settings == null || (
      var.user_settings_canvas_app_settings.kendra_settings == null ||
      var.user_settings_canvas_app_settings.kendra_settings.status == null ||
      contains(["ENABLED", "DISABLED"], var.user_settings_canvas_app_settings.kendra_settings.status)
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_canvas_app_settings.kendra_settings.status must be one of: ENABLED, DISABLED."
  }
  validation {
    condition = var.user_settings_canvas_app_settings == null || (
      var.user_settings_canvas_app_settings.model_register_settings == null ||
      var.user_settings_canvas_app_settings.model_register_settings.status == null ||
      contains(["ENABLED", "DISABLED"], var.user_settings_canvas_app_settings.model_register_settings.status)
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_canvas_app_settings.model_register_settings.status must be one of: ENABLED, DISABLED."
  }
  validation {
    condition = var.user_settings_canvas_app_settings == null || (
      var.user_settings_canvas_app_settings.time_series_forecasting_settings == null ||
      var.user_settings_canvas_app_settings.time_series_forecasting_settings.status == null ||
      contains(["ENABLED", "DISABLED"], var.user_settings_canvas_app_settings.time_series_forecasting_settings.status)
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_canvas_app_settings.time_series_forecasting_settings.status must be one of: ENABLED, DISABLED."
  }
}

variable "user_settings_code_editor_app_settings" {
  description = "The Code Editor application settings."
  type = object({
    lifecycle_config_arns = optional(list(string))
    default_resource_spec = optional(object({
      instance_type                 = optional(string)
      lifecycle_config_arn          = optional(string)
      sagemaker_image_arn           = optional(string)
      sagemaker_image_version_alias = optional(string)
      sagemaker_image_version_arn   = optional(string)
    }))
    custom_image = optional(list(object({
      app_image_config_name = string
      image_name            = string
      image_version_number  = optional(number)
    })))
  })
  default = null
  validation {
    condition = var.user_settings_code_editor_app_settings == null || (
      var.user_settings_code_editor_app_settings.custom_image == null ||
      alltrue([
        for img in var.user_settings_code_editor_app_settings.custom_image :
        img.app_image_config_name != null && img.app_image_config_name != "" &&
        img.image_name != null && img.image_name != ""
      ])
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_code_editor_app_settings.custom_image app_image_config_name and image_name must be provided."
  }
}

variable "user_settings_custom_file_system_config" {
  description = "The settings for assigning a custom file system to a user profile. Permitted users can access this file system in Amazon SageMaker AI Studio."
  type = list(object({
    efs_file_system_config = optional(object({
      file_system_id   = string
      file_system_path = string
    }))
  }))
  default = null
  validation {
    condition = var.user_settings_custom_file_system_config == null || (
      alltrue([
        for config in var.user_settings_custom_file_system_config : (
          config.efs_file_system_config == null || (
            config.efs_file_system_config.file_system_id != null && config.efs_file_system_config.file_system_id != "" &&
            config.efs_file_system_config.file_system_path != null && config.efs_file_system_config.file_system_path != ""
          )
        )
      ])
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_custom_file_system_config efs_file_system_config file_system_id and file_system_path must be provided."
  }
}

variable "user_settings_custom_posix_user_config" {
  description = "Details about the POSIX identity that is used for file system operations."
  type = object({
    gid = optional(number)
    uid = optional(number)
  })
  default = null
}

variable "user_settings_default_landing_uri" {
  description = "The default experience that the user is directed to when accessing the domain. The supported values are: studio:: (indicates that Studio is the default experience) or app:JupyterServer: (indicates that Studio Classic is the default experience)."
  type        = string
  default     = null
}

variable "user_settings_execution_role" {
  description = "The execution role ARN for the user."
  type        = string
  validation {
    condition     = var.user_settings_execution_role != null && var.user_settings_execution_role != ""
    error_message = "resource_aws_sagemaker_user_profile, user_settings_execution_role must be provided and cannot be empty."
  }
}

variable "user_settings_jupyter_lab_app_settings" {
  description = "The settings for the JupyterLab application."
  type = object({
    built_in_lifecycle_config_arn = optional(string)
    lifecycle_config_arns         = optional(list(string))
    app_lifecycle_management = optional(object({
      idle_settings = optional(object({
        idle_timeout_in_minutes     = optional(number)
        lifecycle_management        = optional(string)
        max_idle_timeout_in_minutes = optional(number)
        min_idle_timeout_in_minutes = optional(number)
      }))
    }))
    code_repository = optional(list(object({
      repository_url = optional(string)
    })))
    default_resource_spec = optional(object({
      instance_type                 = optional(string)
      lifecycle_config_arn          = optional(string)
      sagemaker_image_arn           = optional(string)
      sagemaker_image_version_alias = optional(string)
      sagemaker_image_version_arn   = optional(string)
    }))
    emr_settings = optional(object({
      assumable_role_arns = optional(list(string))
      execution_role_arns = optional(list(string))
    }))
  })
  default = null
  validation {
    condition = var.user_settings_jupyter_lab_app_settings == null || (
      var.user_settings_jupyter_lab_app_settings.app_lifecycle_management == null ||
      var.user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings == null || (
        (var.user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings.idle_timeout_in_minutes == null ||
          (var.user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings.idle_timeout_in_minutes >= 60 &&
        var.user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings.idle_timeout_in_minutes <= 525600)) &&
        (var.user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings.lifecycle_management == null ||
        contains(["ENABLED", "DISABLED"], var.user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings.lifecycle_management)) &&
        (var.user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings.max_idle_timeout_in_minutes == null ||
          (var.user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings.max_idle_timeout_in_minutes >= 60 &&
        var.user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings.max_idle_timeout_in_minutes <= 525600)) &&
        (var.user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings.min_idle_timeout_in_minutes == null ||
          (var.user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings.min_idle_timeout_in_minutes >= 60 &&
        var.user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings.min_idle_timeout_in_minutes <= 525600))
      )
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_jupyter_lab_app_settings.app_lifecycle_management.idle_settings timeout values must be between 60 and 525600 minutes, lifecycle_management must be ENABLED or DISABLED."
  }
}

variable "user_settings_jupyter_server_app_settings" {
  description = "The Jupyter server's app settings."
  type = object({
    lifecycle_config_arns = optional(list(string))
    code_repository = optional(list(object({
      repository_url = optional(string)
    })))
    default_resource_spec = optional(object({
      instance_type                 = optional(string)
      lifecycle_config_arn          = optional(string)
      sagemaker_image_arn           = optional(string)
      sagemaker_image_version_alias = optional(string)
      sagemaker_image_version_arn   = optional(string)
    }))
  })
  default = null
}

variable "user_settings_kernel_gateway_app_settings" {
  description = "The kernel gateway app settings."
  type = object({
    lifecycle_config_arns = optional(list(string))
    custom_image = optional(list(object({
      app_image_config_name = string
      image_name            = string
      image_version_number  = optional(number)
    })))
    default_resource_spec = optional(object({
      instance_type                 = optional(string)
      lifecycle_config_arn          = optional(string)
      sagemaker_image_arn           = optional(string)
      sagemaker_image_version_alias = optional(string)
      sagemaker_image_version_arn   = optional(string)
    }))
  })
  default = null
  validation {
    condition = var.user_settings_kernel_gateway_app_settings == null || (
      var.user_settings_kernel_gateway_app_settings.custom_image == null ||
      alltrue([
        for img in var.user_settings_kernel_gateway_app_settings.custom_image :
        img.app_image_config_name != null && img.app_image_config_name != "" &&
        img.image_name != null && img.image_name != ""
      ])
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_kernel_gateway_app_settings.custom_image app_image_config_name and image_name must be provided."
  }
}

variable "user_settings_r_session_app_settings" {
  description = "The RSession app settings."
  type = object({
    custom_image = optional(list(object({
      app_image_config_name = string
      image_name            = string
      image_version_number  = optional(number)
    })))
    default_resource_spec = optional(object({
      instance_type                 = optional(string)
      lifecycle_config_arn          = optional(string)
      sagemaker_image_arn           = optional(string)
      sagemaker_image_version_alias = optional(string)
      sagemaker_image_version_arn   = optional(string)
    }))
  })
  default = null
  validation {
    condition = var.user_settings_r_session_app_settings == null || (
      var.user_settings_r_session_app_settings.custom_image == null ||
      alltrue([
        for img in var.user_settings_r_session_app_settings.custom_image :
        img.app_image_config_name != null && img.app_image_config_name != "" &&
        img.image_name != null && img.image_name != ""
      ])
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_r_session_app_settings.custom_image app_image_config_name and image_name must be provided."
  }
}

variable "user_settings_r_studio_server_pro_app_settings" {
  description = "A collection of settings that configure user interaction with the RStudioServerPro app."
  type = object({
    access_status = optional(string)
    user_group    = optional(string)
  })
  default = null
  validation {
    condition = var.user_settings_r_studio_server_pro_app_settings == null || (
      var.user_settings_r_studio_server_pro_app_settings.access_status == null ||
      contains(["ENABLED", "DISABLED"], var.user_settings_r_studio_server_pro_app_settings.access_status)
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_r_studio_server_pro_app_settings.access_status must be one of: ENABLED, DISABLED."
  }
  validation {
    condition = var.user_settings_r_studio_server_pro_app_settings == null || (
      var.user_settings_r_studio_server_pro_app_settings.user_group == null ||
      contains(["R_STUDIO_USER", "R_STUDIO_ADMIN"], var.user_settings_r_studio_server_pro_app_settings.user_group)
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_r_studio_server_pro_app_settings.user_group must be one of: R_STUDIO_USER, R_STUDIO_ADMIN."
  }
}

variable "user_settings_security_groups" {
  description = "A list of security group IDs that will be attached to the user."
  type        = list(string)
  default     = null
}

variable "user_settings_sharing_settings" {
  description = "The sharing settings."
  type = object({
    notebook_output_option = optional(string)
    s3_kms_key_id          = optional(string)
    s3_output_path         = optional(string)
  })
  default = null
  validation {
    condition = var.user_settings_sharing_settings == null || (
      var.user_settings_sharing_settings.notebook_output_option == null ||
      contains(["Allowed", "Disabled"], var.user_settings_sharing_settings.notebook_output_option)
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_sharing_settings.notebook_output_option must be one of: Allowed, Disabled."
  }
}

variable "user_settings_space_storage_settings" {
  description = "The storage settings for a private space."
  type = object({
    default_ebs_storage_settings = optional(object({
      default_ebs_volume_size_in_gb = number
      maximum_ebs_volume_size_in_gb = number
    }))
  })
  default = null
  validation {
    condition = var.user_settings_space_storage_settings == null || (
      var.user_settings_space_storage_settings.default_ebs_storage_settings == null || (
        var.user_settings_space_storage_settings.default_ebs_storage_settings.default_ebs_volume_size_in_gb != null &&
        var.user_settings_space_storage_settings.default_ebs_storage_settings.maximum_ebs_volume_size_in_gb != null
      )
    )
    error_message = "resource_aws_sagemaker_user_profile, user_settings_space_storage_settings.default_ebs_storage_settings default_ebs_volume_size_in_gb and maximum_ebs_volume_size_in_gb must be provided."
  }
}

variable "user_settings_studio_web_portal" {
  description = "Whether the user can access Studio. If this value is set to DISABLED, the user cannot access Studio, even if that is the default experience for the domain. Valid values are ENABLED and DISABLED."
  type        = string
  default     = null
  validation {
    condition     = var.user_settings_studio_web_portal == null || contains(["ENABLED", "DISABLED"], var.user_settings_studio_web_portal)
    error_message = "resource_aws_sagemaker_user_profile, user_settings_studio_web_portal must be one of: ENABLED, DISABLED."
  }
}

variable "user_settings_tensor_board_app_settings" {
  description = "The TensorBoard app settings."
  type = object({
    default_resource_spec = optional(object({
      instance_type                 = optional(string)
      lifecycle_config_arn          = optional(string)
      sagemaker_image_arn           = optional(string)
      sagemaker_image_version_alias = optional(string)
      sagemaker_image_version_arn   = optional(string)
    }))
  })
  default = null
}

variable "user_settings_studio_web_portal_settings" {
  description = "The Studio Web Portal settings."
  type = object({
    hidden_app_types      = optional(list(string))
    hidden_instance_types = optional(list(string))
    hidden_ml_tools       = optional(list(string))
  })
  default = null
}