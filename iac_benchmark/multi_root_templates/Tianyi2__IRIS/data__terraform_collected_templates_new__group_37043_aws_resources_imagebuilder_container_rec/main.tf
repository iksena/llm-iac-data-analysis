resource "aws_imagebuilder_container_recipe" "this" {
  name                     = var.name
  version                  = var.recipe_version
  container_type           = var.container_type
  parent_image             = var.parent_image
  description              = var.description
  dockerfile_template_data = var.dockerfile_template_data
  dockerfile_template_uri  = var.dockerfile_template_uri
  kms_key_id               = var.kms_key_id
  platform_override        = var.platform_override
  tags                     = var.tags
  working_directory        = var.working_directory

  target_repository {
    repository_name = var.target_repository.repository_name
    service         = var.target_repository.service
  }

  dynamic "component" {
    for_each = var.components
    content {
      component_arn = component.value.component_arn

      dynamic "parameter" {
        for_each = component.value.parameters != null ? component.value.parameters : []
        content {
          name  = parameter.value.name
          value = parameter.value.value
        }
      }
    }
  }

  dynamic "instance_configuration" {
    for_each = var.instance_configuration != null ? [var.instance_configuration] : []
    content {
      image = instance_configuration.value.image

      dynamic "block_device_mapping" {
        for_each = instance_configuration.value.block_device_mappings != null ? instance_configuration.value.block_device_mappings : []
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
    }
  }
}