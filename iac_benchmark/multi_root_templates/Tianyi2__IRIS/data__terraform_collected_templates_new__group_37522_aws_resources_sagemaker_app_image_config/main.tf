resource "aws_sagemaker_app_image_config" "this" {
  app_image_config_name = var.app_image_config_name
  tags                  = var.tags

  dynamic "code_editor_app_image_config" {
    for_each = var.code_editor_app_image_config != null ? [var.code_editor_app_image_config] : []
    content {
      dynamic "container_config" {
        for_each = code_editor_app_image_config.value.container_config != null ? [code_editor_app_image_config.value.container_config] : []
        content {
          container_arguments             = container_config.value.container_arguments
          container_entrypoint            = container_config.value.container_entrypoint
          container_environment_variables = container_config.value.container_environment_variables
        }
      }

      dynamic "file_system_config" {
        for_each = code_editor_app_image_config.value.file_system_config != null ? [code_editor_app_image_config.value.file_system_config] : []
        content {
          default_gid = file_system_config.value.default_gid
          default_uid = file_system_config.value.default_uid
          mount_path  = file_system_config.value.mount_path
        }
      }
    }
  }

  dynamic "jupyter_lab_image_config" {
    for_each = var.jupyter_lab_image_config != null ? [var.jupyter_lab_image_config] : []
    content {
      dynamic "container_config" {
        for_each = jupyter_lab_image_config.value.container_config != null ? [jupyter_lab_image_config.value.container_config] : []
        content {
          container_arguments             = container_config.value.container_arguments
          container_entrypoint            = container_config.value.container_entrypoint
          container_environment_variables = container_config.value.container_environment_variables
        }
      }

      dynamic "file_system_config" {
        for_each = jupyter_lab_image_config.value.file_system_config != null ? [jupyter_lab_image_config.value.file_system_config] : []
        content {
          default_gid = file_system_config.value.default_gid
          default_uid = file_system_config.value.default_uid
          mount_path  = file_system_config.value.mount_path
        }
      }
    }
  }

  dynamic "kernel_gateway_image_config" {
    for_each = var.kernel_gateway_image_config != null ? [var.kernel_gateway_image_config] : []
    content {
      dynamic "file_system_config" {
        for_each = kernel_gateway_image_config.value.file_system_config != null ? [kernel_gateway_image_config.value.file_system_config] : []
        content {
          default_gid = file_system_config.value.default_gid
          default_uid = file_system_config.value.default_uid
          mount_path  = file_system_config.value.mount_path
        }
      }

      kernel_spec {
        name         = kernel_gateway_image_config.value.kernel_spec.name
        display_name = kernel_gateway_image_config.value.kernel_spec.display_name
      }
    }
  }
}