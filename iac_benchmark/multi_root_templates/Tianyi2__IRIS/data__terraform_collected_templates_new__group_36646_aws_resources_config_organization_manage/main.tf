resource "aws_config_organization_managed_rule" "this" {
  name            = var.name
  rule_identifier = var.rule_identifier

  description                 = var.description
  excluded_accounts           = var.excluded_accounts
  input_parameters            = var.input_parameters
  maximum_execution_frequency = var.maximum_execution_frequency
  region                      = var.region
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