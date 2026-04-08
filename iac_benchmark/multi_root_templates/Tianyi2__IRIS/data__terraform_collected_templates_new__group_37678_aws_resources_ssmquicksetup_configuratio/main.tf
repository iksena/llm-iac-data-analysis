resource "aws_ssmquicksetup_configuration_manager" "this" {
  name        = var.name
  description = var.description
  region      = var.region
  tags        = var.tags

  configuration_definition {
    local_deployment_administration_role_arn = var.configuration_definition.local_deployment_administration_role_arn
    local_deployment_execution_role_name     = var.configuration_definition.local_deployment_execution_role_name
    parameters                               = var.configuration_definition.parameters
    type                                     = var.configuration_definition.type
    type_version                             = var.configuration_definition.type_version
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}