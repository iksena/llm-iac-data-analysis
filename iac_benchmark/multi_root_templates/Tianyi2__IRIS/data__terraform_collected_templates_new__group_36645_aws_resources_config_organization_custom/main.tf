resource "aws_config_organization_custom_rule" "this" {
  lambda_function_arn         = var.lambda_function_arn
  name                        = var.name
  trigger_types               = var.trigger_types
  description                 = var.description
  excluded_accounts           = var.excluded_accounts
  input_parameters            = var.input_parameters
  maximum_execution_frequency = var.maximum_execution_frequency
  resource_id_scope           = var.resource_id_scope
  resource_types_scope        = var.resource_types_scope
  tag_key_scope               = var.tag_key_scope
  tag_value_scope             = var.tag_value_scope

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}