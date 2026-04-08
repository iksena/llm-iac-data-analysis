resource "aws_imagebuilder_image_recipe" "this" {
  name         = var.name
  parent_image = var.parent_image
  version      = var.recipe_version

  region            = var.region
  description       = var.description
  user_data_base64  = var.user_data_base64
  working_directory = var.working_directory
  tags              = var.tags

  dynamic "component" {
    for_each = var.component
    content {
      component_arn = component.value.component_arn

      dynamic "parameter" {
        for_each = component.value.parameter
        content {
          name  = parameter.value.name
          value = parameter.value.value
        }
      }
    }
  }

  dynamic "block_device_mapping" {
    for_each = var.block_device_mapping
    content {
      device_name  = block_device_mapping.value.device_name
      no_device    = block_device_mapping.value.no_device
      virtual_name = block_device_mapping.value.virtual_name

      dynamic "ebs" {
        for_each = block_device_mapping.value.ebs != null ? [block_device_mapping.value.ebs] : []
        content {
          delete_on_termination = ebs.value.delete_on_termination
          encrypted             = ebs.value.encrypted
          iops                  = ebs.value.iops
          kms_key_id            = ebs.value.kms_key_id
          snapshot_id           = ebs.value.snapshot_id
          throughput            = ebs.value.throughput
          volume_size           = ebs.value.volume_size
          volume_type           = ebs.value.volume_type
        }
      }
    }
  }

  dynamic "systems_manager_agent" {
    for_each = var.systems_manager_agent != null ? [var.systems_manager_agent] : []
    content {
      uninstall_after_build = systems_manager_agent.value.uninstall_after_build
    }
  }
}