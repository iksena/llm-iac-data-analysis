variable "app_image_config_name" {
  description = "The name of the App Image Config"
  type        = string
}

variable "code_editor_app_image_config" {
  description = "The CodeEditorAppImageConfig"
  type = object({
    container_config = optional(object({
      container_arguments             = optional(list(string))
      container_entrypoint            = optional(list(string))
      container_environment_variables = optional(map(string))
    }))
    file_system_config = optional(object({
      default_gid = optional(number, 100)
      default_uid = optional(number, 1000)
      mount_path  = optional(string, "/home/sagemaker-user")
    }))
  })
  default = null

  validation {
    condition = var.code_editor_app_image_config == null ? true : (
      var.code_editor_app_image_config.file_system_config == null ? true : (
        var.code_editor_app_image_config.file_system_config.default_gid == null ? true :
        contains([0, 100], var.code_editor_app_image_config.file_system_config.default_gid)
      )
    )
    error_message = "resource_aws_sagemaker_app_image_config, code_editor_app_image_config.file_system_config.default_gid must be 0 or 100."
  }

  validation {
    condition = var.code_editor_app_image_config == null ? true : (
      var.code_editor_app_image_config.file_system_config == null ? true : (
        var.code_editor_app_image_config.file_system_config.default_uid == null ? true :
        contains([0, 1000], var.code_editor_app_image_config.file_system_config.default_uid)
      )
    )
    error_message = "resource_aws_sagemaker_app_image_config, code_editor_app_image_config.file_system_config.default_uid must be 0 or 1000."
  }

  validation {
    condition = var.code_editor_app_image_config == null ? true : (
      var.code_editor_app_image_config.file_system_config == null ? true : (
        (var.code_editor_app_image_config.file_system_config.default_gid == 0 && var.code_editor_app_image_config.file_system_config.default_uid == 0) ||
        (var.code_editor_app_image_config.file_system_config.default_gid == 100 && var.code_editor_app_image_config.file_system_config.default_uid == 1000) ||
        (var.code_editor_app_image_config.file_system_config.default_gid == null || var.code_editor_app_image_config.file_system_config.default_uid == null)
      )
    )
    error_message = "resource_aws_sagemaker_app_image_config, code_editor_app_image_config.file_system_config valid pairs for default_gid and default_uid are [0,0] and [100,1000]."
  }
}

variable "jupyter_lab_image_config" {
  description = "The JupyterLabAppImageConfig"
  type = object({
    container_config = optional(object({
      container_arguments             = optional(list(string))
      container_entrypoint            = optional(list(string))
      container_environment_variables = optional(map(string))
    }))
    file_system_config = optional(object({
      default_gid = optional(number, 100)
      default_uid = optional(number, 1000)
      mount_path  = optional(string, "/home/sagemaker-user")
    }))
  })
  default = null

  validation {
    condition = var.jupyter_lab_image_config == null ? true : (
      var.jupyter_lab_image_config.file_system_config == null ? true : (
        var.jupyter_lab_image_config.file_system_config.default_gid == null ? true :
        contains([0, 100], var.jupyter_lab_image_config.file_system_config.default_gid)
      )
    )
    error_message = "resource_aws_sagemaker_app_image_config, jupyter_lab_image_config.file_system_config.default_gid must be 0 or 100."
  }

  validation {
    condition = var.jupyter_lab_image_config == null ? true : (
      var.jupyter_lab_image_config.file_system_config == null ? true : (
        var.jupyter_lab_image_config.file_system_config.default_uid == null ? true :
        contains([0, 1000], var.jupyter_lab_image_config.file_system_config.default_uid)
      )
    )
    error_message = "resource_aws_sagemaker_app_image_config, jupyter_lab_image_config.file_system_config.default_uid must be 0 or 1000."
  }

  validation {
    condition = var.jupyter_lab_image_config == null ? true : (
      var.jupyter_lab_image_config.file_system_config == null ? true : (
        (var.jupyter_lab_image_config.file_system_config.default_gid == 0 && var.jupyter_lab_image_config.file_system_config.default_uid == 0) ||
        (var.jupyter_lab_image_config.file_system_config.default_gid == 100 && var.jupyter_lab_image_config.file_system_config.default_uid == 1000) ||
        (var.jupyter_lab_image_config.file_system_config.default_gid == null || var.jupyter_lab_image_config.file_system_config.default_uid == null)
      )
    )
    error_message = "resource_aws_sagemaker_app_image_config, jupyter_lab_image_config.file_system_config valid pairs for default_gid and default_uid are [0,0] and [100,1000]."
  }
}

variable "kernel_gateway_image_config" {
  description = "The configuration for the file system and kernels in a SageMaker AI image running as a KernelGateway app"
  type = object({
    file_system_config = optional(object({
      default_gid = optional(number, 100)
      default_uid = optional(number, 1000)
      mount_path  = optional(string, "/home/sagemaker-user")
    }))
    kernel_spec = object({
      name         = string
      display_name = optional(string)
    })
  })
  default = null

  validation {
    condition = var.kernel_gateway_image_config == null ? true : (
      var.kernel_gateway_image_config.file_system_config == null ? true : (
        var.kernel_gateway_image_config.file_system_config.default_gid == null ? true :
        contains([0, 100], var.kernel_gateway_image_config.file_system_config.default_gid)
      )
    )
    error_message = "resource_aws_sagemaker_app_image_config, kernel_gateway_image_config.file_system_config.default_gid must be 0 or 100."
  }

  validation {
    condition = var.kernel_gateway_image_config == null ? true : (
      var.kernel_gateway_image_config.file_system_config == null ? true : (
        var.kernel_gateway_image_config.file_system_config.default_uid == null ? true :
        contains([0, 1000], var.kernel_gateway_image_config.file_system_config.default_uid)
      )
    )
    error_message = "resource_aws_sagemaker_app_image_config, kernel_gateway_image_config.file_system_config.default_uid must be 0 or 1000."
  }

  validation {
    condition = var.kernel_gateway_image_config == null ? true : (
      var.kernel_gateway_image_config.file_system_config == null ? true : (
        (var.kernel_gateway_image_config.file_system_config.default_gid == 0 && var.kernel_gateway_image_config.file_system_config.default_uid == 0) ||
        (var.kernel_gateway_image_config.file_system_config.default_gid == 100 && var.kernel_gateway_image_config.file_system_config.default_uid == 1000) ||
        (var.kernel_gateway_image_config.file_system_config.default_gid == null || var.kernel_gateway_image_config.file_system_config.default_uid == null)
      )
    )
    error_message = "resource_aws_sagemaker_app_image_config, kernel_gateway_image_config.file_system_config valid pairs for default_gid and default_uid are [0,0] and [100,1000]."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

# Validation to ensure exactly one of the three image configs is specified
locals {
  config_count = (
    (var.code_editor_app_image_config != null ? 1 : 0) +
    (var.jupyter_lab_image_config != null ? 1 : 0) +
    (var.kernel_gateway_image_config != null ? 1 : 0)
  )

  validation_check = local.config_count == 1 ? true : tobool("exactly one of code_editor_app_image_config, jupyter_lab_image_config, or kernel_gateway_image_config must be configured.")
}