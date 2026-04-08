# Required variables
variable "auth_mode" {
  description = "The mode of authentication that members use to access the domain"
  type        = string
  validation {
    condition     = contains(["IAM", "SSO"], var.auth_mode)
    error_message = "resource_aws_sagemaker_domain, auth_mode must be either 'IAM' or 'SSO'."
  }
}

variable "default_space_settings" {
  description = "The default space settings"
  type = object({
    execution_role = string
    jupyter_server_app_settings = optional(object({
      code_repository = optional(list(object({
        repository_url = optional(string)
      })), [])
      default_resource_spec = optional(object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      }))
      lifecycle_config_arns = optional(list(string), [])
    }))
    kernel_gateway_app_settings = optional(object({
      custom_image = optional(list(object({
        app_image_config_name = string
        image_name            = string
        image_version_number  = optional(number)
      })), [])
      default_resource_spec = optional(object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      }))
      lifecycle_config_arns = optional(list(string), [])
    }))
    security_groups = optional(list(string), [])
    jupyter_lab_app_settings = optional(object({
      app_lifecycle_management = optional(object({
        idle_settings = optional(object({
          idle_timeout_in_minutes     = optional(number)
          lifecycle_management        = optional(string)
          max_idle_timeout_in_minutes = optional(number)
          min_idle_timeout_in_minutes = optional(number)
        }))
      }))
      built_in_lifecycle_config_arn = optional(string)
      code_repository = optional(list(object({
        repository_url = optional(string)
      })), [])
      custom_image = optional(list(object({
        app_image_config_name = string
        image_name            = string
        image_version_number  = optional(number)
      })), [])
      default_resource_spec = optional(object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      }))
      emr_settings = optional(object({
        assumable_role_arns = optional(list(string), [])
        execution_role_arns = optional(list(string), [])
      }))
      lifecycle_config_arns = optional(list(string), [])
    }))
    space_storage_settings = optional(object({
      default_ebs_storage_settings = optional(object({
        default_ebs_volume_size_in_gb = number
        maximum_ebs_volume_size_in_gb = number
      }))
    }))
    custom_posix_user_config = optional(object({
      gid = optional(number)
      uid = optional(number)
    }))
    custom_file_system_config = optional(object({
      efs_file_system_config = optional(object({
        file_system_id   = string
        file_system_path = string
      }))
    }))
  })
  validation {
    condition     = var.default_space_settings.execution_role != null && var.default_space_settings.execution_role != ""
    error_message = "resource_aws_sagemaker_domain, default_space_settings execution_role is required and cannot be empty."
  }
}

variable "default_user_settings" {
  description = "The default user settings"
  type = object({
    execution_role      = string
    auto_mount_home_efs = optional(string)
    canvas_app_settings = optional(object({
      direct_deploy_settings = optional(object({
        status = optional(string)
      }))
      identity_provider_oauth_settings = optional(list(object({
        data_source_name = optional(string)
        secret_arn       = optional(string)
        status           = optional(string)
      })), [])
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
    }))
    code_editor_app_settings = optional(object({
      app_lifecycle_management = optional(object({
        idle_settings = optional(object({
          idle_timeout_in_minutes     = optional(number)
          lifecycle_management        = optional(string)
          max_idle_timeout_in_minutes = optional(number)
          min_idle_timeout_in_minutes = optional(number)
        }))
      }))
      built_in_lifecycle_config_arn = optional(string)
      default_resource_spec = optional(object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      }))
      lifecycle_config_arns = optional(list(string), [])
      custom_image = optional(list(object({
        app_image_config_name = string
        image_name            = string
        image_version_number  = optional(number)
      })), [])
    }))
    custom_file_system_config = optional(object({
      efs_file_system_config = optional(object({
        file_system_id   = string
        file_system_path = string
      }))
    }))
    custom_posix_user_config = optional(object({
      gid = optional(number)
      uid = optional(number)
    }))
    default_landing_uri = optional(string)
    jupyter_lab_app_settings = optional(object({
      app_lifecycle_management = optional(object({
        idle_settings = optional(object({
          idle_timeout_in_minutes     = optional(number)
          lifecycle_management        = optional(string)
          max_idle_timeout_in_minutes = optional(number)
          min_idle_timeout_in_minutes = optional(number)
        }))
      }))
      built_in_lifecycle_config_arn = optional(string)
      code_repository = optional(list(object({
        repository_url = optional(string)
      })), [])
      custom_image = optional(list(object({
        app_image_config_name = string
        image_name            = string
        image_version_number  = optional(number)
      })), [])
      default_resource_spec = optional(object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      }))
      emr_settings = optional(object({
        assumable_role_arns = optional(list(string), [])
        execution_role_arns = optional(list(string), [])
      }))
      lifecycle_config_arns = optional(list(string), [])
    }))
    jupyter_server_app_settings = optional(object({
      code_repository = optional(list(object({
        repository_url = optional(string)
      })), [])
      default_resource_spec = optional(object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      }))
      lifecycle_config_arns = optional(list(string), [])
    }))
    kernel_gateway_app_settings = optional(object({
      custom_image = optional(list(object({
        app_image_config_name = string
        image_name            = string
        image_version_number  = optional(number)
      })), [])
      default_resource_spec = optional(object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      }))
      lifecycle_config_arns = optional(list(string), [])
    }))
    r_session_app_settings = optional(object({
      custom_image = optional(list(object({
        app_image_config_name = string
        image_name            = string
        image_version_number  = optional(number)
      })), [])
      default_resource_spec = optional(object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      }))
    }))
    r_studio_server_pro_app_settings = optional(object({
      access_status = optional(string)
      user_group    = optional(string)
    }))
    security_groups = optional(list(string), [])
    sharing_settings = optional(object({
      notebook_output_option = optional(string)
      s3_kms_key_id          = optional(string)
      s3_output_path         = optional(string)
    }))
    space_storage_settings = optional(object({
      default_ebs_storage_settings = optional(object({
        default_ebs_volume_size_in_gb = number
        maximum_ebs_volume_size_in_gb = number
      }))
    }))
    studio_web_portal = optional(string)
    tensor_board_app_settings = optional(object({
      default_resource_spec = optional(object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      }))
    }))
    studio_web_portal_settings = optional(object({
      hidden_app_types      = optional(list(string), [])
      hidden_instance_types = optional(list(string), [])
      hidden_ml_tools       = optional(list(string), [])
    }))
  })
  validation {
    condition     = var.default_user_settings.execution_role != null && var.default_user_settings.execution_role != ""
    error_message = "resource_aws_sagemaker_domain, default_user_settings execution_role is required and cannot be empty."
  }
  validation {
    condition     = var.default_user_settings.auto_mount_home_efs == null ? true : contains(["Enabled", "Disabled", "DefaultAsDomain"], var.default_user_settings.auto_mount_home_efs)
    error_message = "resource_aws_sagemaker_domain, default_user_settings auto_mount_home_efs must be one of 'Enabled', 'Disabled', or 'DefaultAsDomain'."
  }
  validation {
    condition     = var.default_user_settings.studio_web_portal == null ? true : contains(["ENABLED", "DISABLED"], var.default_user_settings.studio_web_portal)
    error_message = "resource_aws_sagemaker_domain, default_user_settings studio_web_portal must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "domain_name" {
  description = "The domain name"
  type        = string
  validation {
    condition     = var.domain_name != null && var.domain_name != ""
    error_message = "resource_aws_sagemaker_domain, domain_name is required and cannot be empty."
  }
}

variable "subnet_ids" {
  description = "The VPC subnets that Studio uses for communication"
  type        = list(string)
  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_sagemaker_domain, subnet_ids must contain at least one subnet ID."
  }
}

variable "vpc_id" {
  description = "The ID of the Amazon Virtual Private Cloud (VPC) that Studio uses for communication"
  type        = string
  validation {
    condition     = var.vpc_id != null && var.vpc_id != ""
    error_message = "resource_aws_sagemaker_domain, vpc_id is required and cannot be empty."
  }
}

# Optional variables
variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "app_network_access_type" {
  description = "Specifies the VPC used for non-EFS traffic"
  type        = string
  default     = "PublicInternetOnly"
  validation {
    condition     = contains(["PublicInternetOnly", "VpcOnly"], var.app_network_access_type)
    error_message = "resource_aws_sagemaker_domain, app_network_access_type must be either 'PublicInternetOnly' or 'VpcOnly'."
  }
}

variable "app_security_group_management" {
  description = "The entity that creates and manages the required security groups for inter-app communication in VPCOnly mode"
  type        = string
  default     = null
  validation {
    condition     = var.app_security_group_management == null ? true : contains(["Service", "Customer"], var.app_security_group_management)
    error_message = "resource_aws_sagemaker_domain, app_security_group_management must be either 'Service' or 'Customer'."
  }
}

variable "domain_settings" {
  description = "The domain settings"
  type = object({
    docker_settings = optional(object({
      enable_docker_access      = optional(string)
      vpc_only_trusted_accounts = optional(list(string), [])
    }))
    execution_role_identity_config = optional(string)
    r_studio_server_pro_domain_settings = optional(object({
      default_resource_spec = optional(object({
        instance_type                 = optional(string)
        lifecycle_config_arn          = optional(string)
        sagemaker_image_arn           = optional(string)
        sagemaker_image_version_alias = optional(string)
        sagemaker_image_version_arn   = optional(string)
      }))
      domain_execution_role_arn    = string
      r_studio_connect_url         = optional(string)
      r_studio_package_manager_url = optional(string)
    }))
    security_group_ids = optional(list(string), [])
  })
  default = null
  validation {
    condition = var.domain_settings == null ? true : (
      var.domain_settings.execution_role_identity_config == null ? true :
      contains(["USER_PROFILE_NAME", "DISABLED"], var.domain_settings.execution_role_identity_config)
    )
    error_message = "resource_aws_sagemaker_domain, domain_settings execution_role_identity_config must be either 'USER_PROFILE_NAME' or 'DISABLED'."
  }
  validation {
    condition = var.domain_settings == null ? true : (
      var.domain_settings.docker_settings == null ? true : (
        var.domain_settings.docker_settings.enable_docker_access == null ? true :
        contains(["ENABLED", "DISABLED"], var.domain_settings.docker_settings.enable_docker_access)
      )
    )
    error_message = "resource_aws_sagemaker_domain, domain_settings docker_settings enable_docker_access must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "kms_key_id" {
  description = "The AWS KMS customer managed CMK used to encrypt the EFS volume attached to the domain"
  type        = string
  default     = null
}

variable "retention_policy" {
  description = "The retention policy for this domain"
  type = object({
    home_efs_file_system = optional(string, "Retain")
  })
  default = null
  validation {
    condition     = var.retention_policy == null ? true : contains(["Retain", "Delete"], var.retention_policy.home_efs_file_system)
    error_message = "resource_aws_sagemaker_domain, retention_policy home_efs_file_system must be either 'Retain' or 'Delete'."
  }
}

variable "tag_propagation" {
  description = "Indicates whether custom tag propagation is supported for the domain"
  type        = string
  default     = "DISABLED"
  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.tag_propagation)
    error_message = "resource_aws_sagemaker_domain, tag_propagation must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}