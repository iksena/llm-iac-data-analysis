resource "aws_config_organization_custom_policy_rule" "this" {
  name           = var.name
  policy_text    = var.policy_text
  policy_runtime = var.policy_runtime
  trigger_types  = var.trigger_types

  region                      = var.region
  description                 = var.description
  debug_log_delivery_accounts = var.debug_log_delivery_accounts
  excluded_accounts           = var.excluded_accounts
  input_parameters            = var.input_parameters
  maximum_execution_frequency = var.maximum_execution_frequency
  resource_id_scope           = var.resource_id_scope
  resource_types_scope        = var.resource_types_scope
  tag_key_scope               = var.tag_key_scope
  tag_value_scope             = var.tag_value_scope

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}