resource "aws_imagebuilder_image" "this" {
  infrastructure_configuration_arn = var.infrastructure_configuration_arn

  region                          = var.region
  container_recipe_arn            = var.container_recipe_arn
  distribution_configuration_arn  = var.distribution_configuration_arn
  enhanced_image_metadata_enabled = var.enhanced_image_metadata_enabled
  execution_role                  = var.execution_role
  image_recipe_arn                = var.image_recipe_arn

  dynamic "image_tests_configuration" {
    for_each = var.image_tests_configuration != null ? [var.image_tests_configuration] : []
    content {
      image_tests_enabled = image_tests_configuration.value.image_tests_enabled
      timeout_minutes     = image_tests_configuration.value.timeout_minutes
    }
  }

  dynamic "image_scanning_configuration" {
    for_each = var.image_scanning_configuration != null ? [var.image_scanning_configuration] : []
    content {
      image_scanning_enabled = image_scanning_configuration.value.image_scanning_enabled

      dynamic "ecr_configuration" {
        for_each = image_scanning_configuration.value.ecr_configuration != null ? [image_scanning_configuration.value.ecr_configuration] : []
        content {
          repository_name = ecr_configuration.value.repository_name
          container_tags  = ecr_configuration.value.container_tags
        }
      }
    }
  }

  dynamic "workflow" {
    for_each = var.workflow != null ? var.workflow : []
    content {
      workflow_arn   = workflow.value.workflow_arn
      on_failure     = workflow.value.on_failure
      parallel_group = workflow.value.parallel_group

      dynamic "parameter" {
        for_each = workflow.value.parameter != null ? workflow.value.parameter : []
        content {
          name  = parameter.value.name
          value = parameter.value.value
        }
      }
    }
  }

  tags = var.tags

  timeouts {
    create = var.create_timeout
  }
}